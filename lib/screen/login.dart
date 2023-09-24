import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/app_config.dart';
import 'package:flutter_application_1/models/users.dart';
import 'package:flutter_application_1/screen/homepage.dart';
import 'package:flutter_application_1/screen/cartpage.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class Login extends StatefulWidget {
  static const routeName = "/login";
  final Function(int?)
      callbackLogin; // Change the callback type to accept an integer or null

  Login({required this.callbackLogin, Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formkey = GlobalKey<FormState>();
  Users user = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Network Image)
          Positioned.fill(
            child: Image.network(
              'https://w0.peakpx.com/wallpaper/204/797/HD-wallpaper-mario-nintendo-red-rouge.jpg', // Replace with your image URL
              fit: BoxFit.cover,
            ),
          ),

          // // Blurred Background Overlay
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 1, sigmaY: 5), // Adjust blur intensity as needed
          //     child: Container(
          //       color: Colors.black.withOpacity(0.6), // Adjust opacity and color as needed
          //     ),
          //   ),
          // ),

          // Content
          Center(
            child: Container(
              margin: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius: BorderRadius.circular(
                    10.0), // Set border radius for curvature
              ),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Use MainAxisSize.min to fit the content
                  children: [
                    SizedBox(height: 20.0),
                    textHeader(),
                    SizedBox(height: 15.0),
                    emailInputField(),
                    SizedBox(height: 10.0),
                    passwordInputField(),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        submitButton(),
                        SizedBox(height: 80.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textHeader() {
    return SizedBox(
        width: 300,
        height: 60,
        child: Center(
          child: Text(
            "Nintendo Account",
            style: TextStyle(
                color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget emailInputField() {
    return SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          child: Container(
            color: Colors
                .white, // Set the background color of the container to white
            child: TextFormField(
              initialValue: "test@gmail.com",
              decoration: InputDecoration(
                labelText: "Email:",
                icon: Icon(Icons.email, color: Colors.black),
                labelStyle: TextStyle(
                    color: Colors.black), // Set label text color to black
                hintStyle: TextStyle(
                    color: Colors.black), // Set hint text color to black
                // You can also set other styles like focusedBorder, enabledBorder, etc. here
              ),
              style: TextStyle(color: Colors.black), // Set text color to black
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field is required";
                }
                if (!EmailValidator.validate(value)) {
                  return "It is not an email format";
                }
                return null;
              },
              onSaved: (newValue) => user.email = newValue,
            ),
          ),
        ));
  }

  Widget passwordInputField() {
    return SizedBox(
        width: 300,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          child: Container(
            color: Colors
                .white, // Set the background color of the container to white
            child: TextFormField(
              initialValue: "1q2w3e4r",
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password:",
                icon: Icon(Icons.lock, color: Colors.black),
                labelStyle: TextStyle(
                    color: Colors.black), // Set label text color to black
                hintStyle: TextStyle(
                    color: Colors.black), // Set hint text color to black
                // You can also set other styles like focusedBorder, enabledBorder, etc. here
              ),
              style: TextStyle(color: Colors.black), // Set text color to black
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
              onSaved: (newValue) => user.password = newValue,
            ),
          ),
        ));
  }

  Widget submitButton() {
    return SizedBox(
        width: 300,
        child: ClipRRect(
          child: SizedBox(
            width: 200.0,
            child: ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  print(user.toJson().toString());
                  login(user);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // Set the border radius
                ),
              ),
              child: Text("Sign in"),
            ),
          ),
        ));
  }

  Future<void> login(Users user) async {
    try {
      var params = {"email": user.email, "password": user.password};
      var url = Uri.http(AppConfig.server, "users", params);
      var resp = await http.get(url);

      if (resp.statusCode == 200) {
        List<Users> login_result = usersFromJson(resp.body);

        if (login_result.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Username or password invalid")),
          );
        } else {
          // Store the user's ID
          int userId = login_result[0].id ??
              0; // Replace 0 with a default value if id is null
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Success")),
          );
          // Call the callback function with the userId
          widget.callbackLogin(userId);
          print(userId);
          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainApp(
                userId: userId,
                logoutCallback: () {
                  // Handle logout callback
                },
              ),
            ),
          );
        }
      }
      ;
    } catch (e) {
      // Handle other errors, such as network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout Success")),
      );
      print("Error during login: $e");
    }
  }
}
