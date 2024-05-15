// To parse this JSON data, do
//
//     final shopLoginModel = shopLoginModelFromJson(jsonString);

import 'dart:convert';

ShopLoginModel shopLoginModelFromJson(String str) => ShopLoginModel.fromJson(json.decode(str));


class ShopLoginModel {
  bool? success;
  String? userID;

  ShopLoginModel({
    this.success,
    this.userID,
  });

  factory ShopLoginModel.fromJson(Map<String, dynamic> json) => ShopLoginModel(
    success: json["success"],
    userID: json["userID"],
  );

}
