// To parse this JSON data, do
//
//     final usersSearch = usersSearchFromJson(jsonString);

import 'dart:convert';

UsersSearch usersSearchFromJson(String str) => UsersSearch.fromJson(json.decode(str));

String usersSearchToJson(UsersSearch data) => json.encode(data.toJson());

class UsersSearch {
  List<Search>? search;

  UsersSearch({
    this.search,
  });

  factory UsersSearch.fromJson(Map<String, dynamic> json) => UsersSearch(
    search: json["search"] == null ? [] : List<Search>.from(json["search"]!.map((x) => Search.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "search": search == null ? [] : List<dynamic>.from(search!.map((x) => x.toJson())),
  };
}

class Search {
  String? username;
  AccountType? accountType;

  Search({
    this.username,
    this.accountType,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    username: json["username"],
    accountType: accountTypeValues.map[json["account_type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "account_type": accountTypeValues.reverse[accountType],
  };
}

enum AccountType {
  BOT,
  HUMAN
}

final accountTypeValues = EnumValues({
  "bot": AccountType.BOT,
  "human": AccountType.HUMAN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
