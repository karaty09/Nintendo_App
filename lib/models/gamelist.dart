// To parse this JSON data, do
//
//     final gamelist = gamelistFromJson(jsonString);

import 'dart:convert';

List<Gamelist> gamelistFromJson(String str) => List<Gamelist>.from(json.decode(str).map((x) => Gamelist.fromJson(x)));

String gamelistToJson(List<Gamelist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gamelist {
    String? title;
    String? type;
    String? release;
    double? price;
    int? total;

    Gamelist({
        this.title,
        this.type,
        this.release,
        this.price,
        this.total,
    });

    factory Gamelist.fromJson(Map<String, dynamic> json) => Gamelist(
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
