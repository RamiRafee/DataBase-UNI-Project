// To parse this JSON data, do
//
//     final getUserDefault = getUserDefaultFromJson(jsonString);

import 'dart:convert';

GetUserDefault getUserDefaultFromJson(String str) => GetUserDefault.fromJson(json.decode(str));

String getUserDefaultToJson(GetUserDefault data) => json.encode(data.toJson());

class GetUserDefault {
  bool? success;
  List<User>? users;

  GetUserDefault({
    this.success,
    this.users,
  });

  factory GetUserDefault.fromJson(Map<String, dynamic> json) => GetUserDefault(
    success: json["success"],
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class User {
  String? id;
  String? userLanguage;
  String? username;
  String? password;
  Sex? sex;
  String? age;
  DateTime? createdAt;
  String? followersCount;
  String? friendsCount;
  String? membershipSubscription;
  String? avgPurchasesPerDay;
  String? accountAge;
  String? prodFavCount;

  User({
    this.id,
    this.userLanguage,
    this.username,
    this.password,
    this.sex,
    this.age,
    this.createdAt,
    this.followersCount,
    this.friendsCount,
    this.membershipSubscription,
    this.avgPurchasesPerDay,
    this.accountAge,
    this.prodFavCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["ID"],
    userLanguage: json["UserLanguage"],
    username: json["Username"],
    password: json["Password"],
    sex: sexValues.map[json["sex"]]!,
    age: json["age"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    followersCount: json["FollowersCount"],
    friendsCount: json["FriendsCount"],
    membershipSubscription: json["MembershipSubscription"],
    avgPurchasesPerDay: json["AvgPurchasesPerDay"],
    accountAge: json["AccountAge"],
    prodFavCount: json["prod_fav_count"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "UserLanguage": userLanguage,
    "Username": username,
    "Password": password,
    "sex": sexValues.reverse[sex],
    "age": age,
    "CreatedAt": createdAt?.toIso8601String(),
    "FollowersCount": followersCount,
    "FriendsCount": friendsCount,
    "MembershipSubscription": membershipSubscription,
    "AvgPurchasesPerDay": avgPurchasesPerDay,
    "AccountAge": accountAge,
    "prod_fav_count": prodFavCount,
  };
}

enum Sex {
  F,
  M
}

final sexValues = EnumValues({
  "F": Sex.F,
  "M": Sex.M
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
