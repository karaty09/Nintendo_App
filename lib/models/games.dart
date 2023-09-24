// To parse this JSON data, do
//
//     final games = gamesFromJson(jsonString);

import 'dart:convert';

List<Games> gamesFromJson(String str) => List<Games>.from(json.decode(str).map((x) => Games.fromJson(x)));

String gamesToJson(List<Games> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Games {
    int? id;
    String? title;
    String? type;
    String? release;
    double? price;
    String? detail;
    String? picture;

    Games({
        this.id,
        this.title,
        this.type,
        this.release,
        this.price,
        this.detail,
        this.picture,
    });

    factory Games.fromJson(Map<String, dynamic> json) => Games(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        release: json["release"],
        price: json["price"]?.toDouble(),
        detail: json["detail"],
        picture: json["picture"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "release": release,
        "price": price,
        "detail": detail,
        "picture": picture,
    };
}
