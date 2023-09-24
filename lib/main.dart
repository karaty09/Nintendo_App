import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screen/login.dart';
import 'screen/homepage.dart';
import 'screen/cartpage.dart';
import 'screen/receiptpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  int? _userId;

  void _login(int? userId) {
    setState(() {
      _isLoggedIn =
          userId != null; // Set _isLoggedIn to true if userId is not null
      _userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home(userId: _userId),
        '/login': (context) => Login(callbackLogin: _login),
        '/cart': (context) => CartPage(userId: _userId),
        '/receipt': (context) => ReceiptPage(userId: _userId),
      },
      home: _isLoggedIn
          ? MainApp(
              userId: _userId,
              logoutCallback: () {
                setState(() {
                  _isLoggedIn = false;
                  _userId = null;
                });
              },
            )
          : Login(callbackLogin: _login),
    );
  }
}

class MainApp extends StatefulWidget {
  final int? userId;
  final VoidCallback logoutCallback; // Callback to logout

  MainApp({
    required this.userId,
    required this.logoutCallback,
    Key? key,
  }) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(userId: widget.userId),
      CartPage(userId: widget.userId),
      ReceiptPage(userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Access the selected page here
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Receipt',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
