// To parse this JSON data, do
//
//     final receipt = receiptFromJson(jsonString);

import 'dart:convert';

List<Receipt> receiptFromJson(String str) =>
    List<Receipt>.from(json.decode(str).map((x) => Receipt.fromJson(x)));

String receiptToJson(List<Receipt> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Receipt {
  DateTime? time;
  int? userId;
  List<Game>? game;
  double? total;
  int? id;

  Receipt({
    this.time,
    this.userId,
    this.game,
    this.total,
    this.id,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        time: json["Time"] == null ? null : DateTime.parse(json["Time"]),
        userId: json["userId"],
        game: json["game"] == null
            ? []
            : List<Game>.from(json["game"]!.map((x) => Game.fromJson(x))),
        total: json["total"]?.toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "Time": time?.toIso8601String(),
        "userId": userId,
        "game": game == null
            ? []
            : List<dynamic>.from(game!.map((x) => x.toJson())),
        "total": total,
        "id": id,
      };
}

class Game {
  String? title;
  String? type;
  String? release;
  double? price;
  int? total;

  Game({
    this.title,
    this.type,
    this.release,
    this.price,
    this.total,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        title: json["title"],
        type: json["type"],
        release: json["release"],
        price: json["price"]?.toDouble(),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "release": release,
        "price": price,
        "total": total,
      };
}
