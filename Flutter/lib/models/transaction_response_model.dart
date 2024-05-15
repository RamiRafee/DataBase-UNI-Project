// To parse this JSON data, do
//
//     final transactionResponse = transactionResponseFromJson(jsonString);

import 'dart:convert';

TransactionResponse transactionResponseFromJson(String str) => TransactionResponse.fromJson(json.decode(str));

String transactionResponseToJson(TransactionResponse data) => json.encode(data.toJson());

class TransactionResponse {
  String? numberOfItems;
  String? purchaseValue;
  String? orderId;

  TransactionResponse({
    this.numberOfItems,
    this.purchaseValue,
    this.orderId,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
    numberOfItems: json["numberOfItems"],
    purchaseValue: json["purchaseValue"],
    orderId: json["orderID"],
  );

  Map<String, dynamic> toJson() => {
    "numberOfItems": numberOfItems,
    "purchaseValue": purchaseValue,
    "orderID": orderId,
  };
}
