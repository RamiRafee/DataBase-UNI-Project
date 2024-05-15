// To parse this JSON data, do
//
//     final fraudulentProductsModel = fraudulentProductsModelFromJson(jsonString);

import 'dart:convert';

FraudulentProductsModel fraudulentProductsModelFromJson(String str) => FraudulentProductsModel.fromJson(json.decode(str));

String fraudulentProductsModelToJson(FraudulentProductsModel data) => json.encode(data.toJson());

class FraudulentProductsModel {
  List<FraudulentProduct>? fraudulentProducts;

  FraudulentProductsModel({
    this.fraudulentProducts,
  });

  factory FraudulentProductsModel.fromJson(Map<String, dynamic> json) => FraudulentProductsModel(
    fraudulentProducts: json["fraudulent_products"] == null ? [] : List<FraudulentProduct>.from(json["fraudulent_products"]!.map((x) => FraudulentProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fraudulent_products": fraudulentProducts == null ? [] : List<dynamic>.from(fraudulentProducts!.map((x) => x.toJson())),
  };
}

class FraudulentProduct {
  String? id;
  String? title;
  String? price;
  String? url;
  String? asin;
  List<String>? imageUrLs;
  String? fraudulentProductMark;
  String? maliciousUrlMark;

  FraudulentProduct({
    this.id,
    this.title,
    this.price,
    this.url,
    this.asin,
    this.imageUrLs,
    this.fraudulentProductMark,
    this.maliciousUrlMark,
  });

  factory FraudulentProduct.fromJson(Map<String, dynamic> json) => FraudulentProduct(
    id: json["ID"],
    title: json["Title"],
    price: json["Price"],
    url: json["URL"],
    asin: json["ASIN"],
    imageUrLs: json["ImageURLs"] == null ? [] : List<String>.from(json["ImageURLs"]!.map((x) => x)),
    fraudulentProductMark: json["FraudulentProductMark"],
    maliciousUrlMark: json["MaliciousURLMark"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "Price": price,
    "URL": url,
    "ASIN": asin,
    "ImageURLs": imageUrLs == null ? [] : List<dynamic>.from(imageUrLs!.map((x) => x)),
    "FraudulentProductMark": fraudulentProductMark,
    "MaliciousURLMark": maliciousUrlMark,
  };
}
