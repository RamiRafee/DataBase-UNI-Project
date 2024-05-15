// To parse this JSON data, do
//
//     final userDetectedModel = userDetectedModelFromJson(jsonString);

import 'dart:convert';

List<UserDetectedModel> userDetectedModelFromJson(String str) => List<UserDetectedModel>.from(json.decode(str).map((x) => UserDetectedModel.fromJson(x)));

String userDetectedModelToJson(List<UserDetectedModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDetectedModel {
  String? userid;
  String? username;
  String? prediction;

  UserDetectedModel({
    this.userid,
    this.username,
    this.prediction,
  });

  factory UserDetectedModel.fromJson(Map<String, dynamic> json) => UserDetectedModel(
    userid: json["userid"],
    username: json["username"],
    prediction: json["prediction"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "username": username,
    "prediction": prediction,
  };
}
