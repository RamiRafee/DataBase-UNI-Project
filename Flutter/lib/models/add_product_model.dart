// To parse this JSON data, do
//
//     final addProductModel = addProductModelFromJson(jsonString);

import 'dart:convert';

AddProductModel addProductModelFromJson(String str) => AddProductModel.fromJson(json.decode(str));

String addProductModelToJson(AddProductModel data) => json.encode(data.toJson());

class AddProductModel {
  String? status;
  String? message;
  Url? url;
  ContentModeration? contentModeration;

  AddProductModel({
    this.status,
    this.message,
    this.url,
    this.contentModeration,
  });

  factory AddProductModel.fromJson(Map<String, dynamic> json) => AddProductModel(
    status: json["status"],
    message: json["message"],
    url: json["url"] == null ? null : Url.fromJson(json["url"]),
    contentModeration: json["content_moderation"] == null ? null : ContentModeration.fromJson(json["content_moderation"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "url": url?.toJson(),
    "content_moderation": contentModeration?.toJson(),
  };
}

class ContentModeration {
  Predictions? predictions;

  ContentModeration({
    this.predictions,
  });

  factory ContentModeration.fromJson(Map<String, dynamic> json) => ContentModeration(
    predictions: json["predictions"] == null ? null : Predictions.fromJson(json["predictions"]),
  );

  Map<String, dynamic> toJson() => {
    "predictions": predictions?.toJson(),
  };
}

class Predictions {
  String? bestModel;
  String? bestModelPrediction;
  dynamic confidence;

  Predictions({
    this.bestModel,
    this.bestModelPrediction,
    this.confidence,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) => Predictions(
    bestModel: json["best_model"],
    bestModelPrediction: json["best_model_prediction"],
    confidence: json["confidence"],
  );

  Map<String, dynamic> toJson() => {
    "best_model": bestModel,
    "best_model_prediction": bestModelPrediction,
    "confidence": confidence,
  };
}

class Url {
  String? predictedType;

  Url({
    this.predictedType,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
    predictedType: json["predicted_type"],
  );

  Map<String, dynamic> toJson() => {
    "predicted_type": predictedType,
  };
}
