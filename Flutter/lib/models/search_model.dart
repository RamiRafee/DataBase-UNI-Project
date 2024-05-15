// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  List<String>? search;

  SearchModel({
    this.search,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    search: json["search"] == null ? [] : List<String>.from(json["search"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "search": search == null ? [] : List<dynamic>.from(search!.map((x) => x)),
  };
}
