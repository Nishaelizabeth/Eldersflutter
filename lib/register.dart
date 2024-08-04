import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {


  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController housenameController=TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a global key for the form

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.cyan),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Colors.white, // Set background color to transparent
      appBar: AppBar(
        title: Text("Elders Helping Syatem"),
        backgroundColor: Colors.green, // Change the app bar color
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(
                //       "assets/background.jpg"), // Set background image
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, // Change the title color
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 20), // Add spacing between title and fields
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your First name';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                        height: 20), // Add spacing between title and fields
                    TextFormField(
                      controller: lastnameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Last name';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                   // Add spacing between title and fields

                    SizedBox(height: 10), // Add spacing between fields
                    TextFormField(
                      controller: placeController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Place",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your place';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),



                    SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Phone",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.transparent, // Set fill color to transparent
                        border: outlineBorder(),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20), // Add spacing before the button
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          print("Not validated");
                        } else {
                          final sh = await SharedPreferences.getInstance();
                          String name = nameController.text.toString();
                          String lname=lastnameController.text.toString();

                          String place = placeController.text.toString();


                          String phone = phoneController.text.toString();
                          String email = emailController.text.toString();
                          String uname = usernameController.text.toString();
                          String pswd = passwordController.text.toString();
                          String url = sh.getString("url").toString();
                          var data = await http.post(
                            Uri.parse(url + "/api/register"),
                            body: {
                              'name': name,
                              'lname':lname,


                              'place': place,

                              'phone': phone,
                              'email': email,
                              'username': uname,
                              'password': pswd,
                            },
                          );

                          var jasondata = json.decode(data.body);
                          String status = jasondata['status'].toString();

                          if (status == "true") {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => LocationPage()),
                            // );
                          } else {
                            print("error======");
                          }
                        }
                      },
                      icon: Icon(Icons.send),
                      label: Text('Submit'),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                        // Change the button color
                      ),
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
