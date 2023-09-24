import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/games.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/app_config.dart';

class InfoGamePage extends StatefulWidget {
  static const String routeName = '/game';
  const InfoGamePage({super.key});

  @override
  _InfoGamePageState createState() => _InfoGamePageState();
}

class _InfoGamePageState extends State<InfoGamePage> {
  Future<void> addgame(String title, double price, String picture, String type,
      String release, int total) async {
    var url = Uri.http(AppConfig.server, "Cart");
    Map<String, dynamic> gameData = {
      "title": title,
      "type": type,
      "price": price,
      "release": release,
      "picture": picture,
      "total": total,
    };
    var resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(gameData));
    var rs = gamesFromJson("[${resp.body}]");

    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final game = ModalRoute.of(context)!.settings.arguments as Games;
    int total = 1;
    double? price = game.price;
    double defaultPrice = 0.0;
    var imgUrl = game.picture;
    imgUrl ??= "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Image.network(
          'https://cdn.freebiesupply.com/logos/large/2x/nintendo-2-logo-png-transparent.png',
          height: 120,
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${game.title}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Image.network(
                      imgUrl,
                      height: 260,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Release: ${game.release}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Type: ${game.type}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${game.detail}',
                    ),
                    SizedBox(height: 20),
                    Text(
                      '\$${game.price}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            addgame(
                                "${game.title}",
                                price ?? defaultPrice,
                                "${game.picture}",
                                "${game.type}",
                                "${game.release}",
                                total);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added to Cart')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 216, 29, 29)),
                          child: Text('Add to Cart'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Buy Now')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              primary:
                                  const Color.fromARGB(255, 134, 134, 134)),
                          child: Text('Buy Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
