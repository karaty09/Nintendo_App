import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/app_config.dart';
import 'package:flutter_application_1/models/receipt.dart';
import 'package:http/http.dart' as http;

class ReceiptPage extends StatefulWidget {
  static const routeName = "/receipt";
  final int? userId;
  const ReceiptPage({Key? key, this.userId}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  int? userId;
  List<Receipt> _receiptlist = [];
  Widget mainBody = Container();

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    print(userId);
    getReceipt(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                backgroundColor: Colors.red,
        title: SizedBox(
          height: 120, // Adjust the height as needed
          child: Image.network(
            'https://cdn.freebiesupply.com/logos/large/2x/nintendo-2-logo-png-transparent.png',
            fit: BoxFit
                .fitHeight, // Ensure the image fits within the specified height
          ),
        ),
      ),
      body: mainBody,
    );
  }

  Future<void> getReceipt(int userId) async {
    try {
      var url = Uri.http(AppConfig.server, "Receipt");
      var resp = await http.get(url);
      print(resp.body);
      if (resp.statusCode == 200) {
        setState(() {
          _receiptlist = receiptFromJson(resp.body).toList();
          mainBody = showReceipt(_receiptlist, userId);
        });
      } else {}
    } catch (e) {}
  }

  Widget showReceipt(List<Receipt> _receiptList, int userId) {
    final filteredReceipts =
        _receiptList.where((receipt) => receipt.userId == userId).toList();

    return Column(
      children: [
        SizedBox(height: 15.0),
        Center(
          child: Text(
            'Receipt list',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredReceipts.length,
            itemBuilder: (context, index) {
              final receipt = filteredReceipts[index];
              final dateTime = receipt.time;
              final games = receipt.game;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Center(
                      child: Text('Date and Time: ${dateTime.toString()}'),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Text('Games:'),
                    ),
                    Column(
                      children: games?.map((game) {
                            return ListTile(
                              title: Text('Title: ${game.title}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${game.type}'),
                                  Text('Release: ${game.release}'),
                                  Text('Price: \$${game.price}'),
                                  Text('Total: ${game.total}'),
                                ],
                              ),
                            );
                          }).toList() ??
                          [],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Total: \$ ${receipt.total}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
