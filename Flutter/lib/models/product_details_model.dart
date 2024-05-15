// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) => ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) => json.encode(data.toJson());

class ProductDetailModel {
  String? id;
  String? title;
  String? asin;
  String? price;
  String? productDetails;
  List<String>? imageUrLs;
  String? brandName;
  String? brandId;
  String? category;
  String? featureDetails;
  String? imageUrl;

  ProductDetailModel({
    this.id,
    this.title,
    this.asin,
    this.price,
    this.productDetails,
    this.imageUrLs,
    this.brandName,
    this.brandId,
    this.category,
    this.featureDetails,
    this.imageUrl,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
    id: json["ID"],
    title: json["Title"],
    asin: json["ASIN"],
    price: json["Price"],
    productDetails: json["ProductDetails"],
    imageUrLs: json["ImageURLs"] == null ? [] : List<String>.from(json["ImageURLs"]!.map((x) => x)),
    brandName: json["BrandName"],
    brandId: json["BrandID"],
    category: json["Category"],
    featureDetails: json["FeatureDetails"],
    imageUrl: json["ImageURL"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "ASIN": asin,
    "Price": price,
    "ProductDetails": productDetails,
    "ImageURLs": imageUrLs == null ? [] : List<dynamic>.from(imageUrLs!.map((x) => x)),
    "BrandName": brandName,
    "BrandID": brandId,
    "Category": category,
    "FeatureDetails": featureDetails,
    "ImageURL": imageUrl,
  };
}
