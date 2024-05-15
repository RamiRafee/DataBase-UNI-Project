// To parse this JSON data, do
//
//     final shopLoginModel = shopLoginModelFromJson(jsonString);

import 'dart:convert';

ShopRegisterModel shopRegisterModelFromJson(String str) => ShopRegisterModel.fromJson(json.decode(str));


class ShopRegisterModel {
  bool? success;
  bool? purchase;
  String? message;

  ShopRegisterModel({
    this.success,
    this.message,
    this.purchase,
  });

  factory ShopRegisterModel.fromJson(Map<String, dynamic> json) => ShopRegisterModel(
    success: json["success"],
    message: json["message"],
    purchase: json["purchase"],
  );

}
