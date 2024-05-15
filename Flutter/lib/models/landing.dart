// To parse this JSON data, do
//
//     final landingModel = landingModelFromJson(jsonString);

import 'dart:convert';

LandingModel landingModelFromJson(String str) => LandingModel.fromJson(json.decode(str));

String landingModelToJson(LandingModel data) => json.encode(data.toJson());

class LandingModel {
  List<LandingProduct>? landingProduct;

  LandingModel({
    this.landingProduct,
  });

  factory LandingModel.fromJson(Map<String, dynamic> json) => LandingModel(
    landingProduct: json["landing_product"] == null ? [] : List<LandingProduct>.from(json["landing_product"]!.map((x) => LandingProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "landing_product": landingProduct == null ? [] : List<dynamic>.from(landingProduct!.map((x) => x.toJson())),
  };
}

class LandingProduct {
  String? id;
  String? title;
  String? price;
  String? url;
  String? asin;
  List<String>? imageUrLs;

  LandingProduct({
    this.id,
    this.title,
    this.price,
    this.url,
    this.asin,
    this.imageUrLs,
  });

  factory LandingProduct.fromJson(Map<String, dynamic> json) => LandingProduct(
    id: json["ID"],
    title: json["Title"],
    price: json["Price"],
    url: json["URL"],
    asin: json["ASIN"],
    imageUrLs: json["ImageURLs"] == null ? [] : List<String>.from(json["ImageURLs"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Title": title,
    "Price": price,
    "URL": url,
    "ASIN": asin,
    "ImageURLs": imageUrLs == null ? [] : List<dynamic>.from(imageUrLs!.map((x) => x)),
  };
}
