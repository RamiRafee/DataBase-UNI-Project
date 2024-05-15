// To parse this JSON data, do
//
//     final powerBi = powerBiFromJson(jsonString);

import 'dart:convert';

PowerBi powerBiFromJson(String str) => PowerBi.fromJson(json.decode(str));

String powerBiToJson(PowerBi data) => json.encode(data.toJson());

class PowerBi {
  List<String>? imageLinks;

  PowerBi({
    this.imageLinks,
  });

  factory PowerBi.fromJson(Map<String, dynamic> json) => PowerBi(
    imageLinks: json["image_links"] == null ? [] : List<String>.from(json["image_links"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "image_links": imageLinks == null ? [] : List<dynamic>.from(imageLinks!.map((x) => x)),
  };
}
