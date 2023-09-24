import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/app_config.dart';
import 'package:flutter_application_1/models/games.dart';
import 'package:flutter_application_1/screen/infogamepage.dart';
import 'package:flutter_application_1/screen/login.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home"; // Corrected routeName type to String
  final int? userId;

  const Home({Key? key, this.userId})
      : super(key: key); // Added userId parameter to the constructor

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();
  List<Games> _gamelist = [];
  String? selectedGenre; // Variable to store the selected genre
  List<Games> filteredGames = [];

  Future<void> getGames() async {
    var url =
        Uri.http(AppConfig.server, "Game"); // Change the endpoint to "games"
    var resp = await http.get(url);
    setState(() {
      _gamelist = gamesFromJson(resp.body);
      mainBody = showGames(_gamelist);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Image.network(
          'https://cdn.freebiesupply.com/logos/large/2x/nintendo-2-logo-png-transparent.png',
          height: 120, // Adjust the height as needed
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: Text("Logout"),
                        onPressed: () {
                          // Perform the logout action here
                          Navigator.pushNamed(context, Login.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: mainBody, // Add the mainBody widget here
    );
  }

  @override
  void initState() {
    super.initState();
    getGames(); // Fetch the games
  }

  Widget showGames(List<Games> _gamelist) {
    final filteredGames = selectedGenre == null
        ? _gamelist
        : _gamelist.where((game) => game.type == selectedGenre).toList();

    List<String> genres = [
      'Show All',
      'Adventure',
      'Simulation',
      'Sports',
      'Fighting',
      'Multiplayer',
      'Role-Playing',
    ];

    // Initialize selectedGenre to the first genre in the list
    selectedGenre ??= genres.first;

    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          'Trending Games',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              final game = _gamelist[index];
              var imgtop =
                  game.picture ?? "https://example.com/default-image.jpg";
              return Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      imgtop,
                      height: 170, // Set the image height
                      width: 300, // Set the image width
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${game.title}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${game.release}-${game.type}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        // Genre selection dropdown
        // Genre selection dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Sort by Genre',
              border: OutlineInputBorder(),
            ),
            value: selectedGenre,
            onChanged: (value) async {
              // Handle genre selection here
              setState(() {
                selectedGenre = value;
              });
              print(value);
              if (selectedGenre == 'Show All') {
                // If "Show All" is selected, set selectedGenre to null
                selectedGenre = null;
              }
              // Refresh the page by fetching games with the new genre
              await getGames();
            },
            items: genres.map((String genre) {
              return DropdownMenuItem<String>(
                value: genre,
                child: Text(genre),
              );
            }).toList(),
          ),
        ),

        // List of games filtered by genre
        Expanded(
          child: ListView.builder(
            itemCount: filteredGames.length,
            itemBuilder: (context, index) {
              Games game = filteredGames[index];
              var imgUrl =
                  game.picture ?? "https://example.com/default-image.jpg";

              return Card(
                child: ListTile(
                  leading: Image.network(
                    imgUrl,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    "${game.title}",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    "${game.release} - ${game.type}",
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoGamePage(),
                        settings: RouteSettings(arguments: game),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
