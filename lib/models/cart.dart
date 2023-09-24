// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
    String? title;
    String? type;
    double? price;
    String? release;
    String? picture;
    int? total;
    int? id;

    Cart({
        this.title,
        this.type,
        this.price,
        this.release,
        this.picture,
        this.total,
        this.id,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        title: json["title"],
        type: json["type"],
        price: json["price"]?.toDouble(),
        release: json["release"],
        picture: json["picture"],
        total: json["total"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "price": price,
        "release": release,
        "picture": picture,
        "total": total,
        "id": id,
    };
}
