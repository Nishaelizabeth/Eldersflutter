import 'dart:convert';
import 'package:elders_flutter/register.dart';
import 'package:elders_flutter/user_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _LoginState();
}

class _LoginState extends State<login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Background image
                Image.asset(
                  'assets/elder_1.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Username",
                    ),
                    // Center-align the entered text
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              print("Not validated");
                            } else {
                              final sh =
                              await SharedPreferences.getInstance();
                              print("===============");
                              String Uname = usernameController.text.toString();
                              String Paswd = passwordController.text.toString();
                              String url = sh.getString("url").toString();
                              print("==========+++++++++++++++++++" + url);
                              print(Uname);
                              print(Paswd);

                              var data = await http.post(
                                Uri.parse(url + "/api/login"),


                                body: {
                                  'username1': Uname,
                                  "password": Paswd,
                                },

                              );
                              print(data);
                              var jasondata = json.decode(data.body);
                              String status = jasondata['type'].toString();
                              print(
                                  "========================++++" + status);

                              if (status == "user") {
                                // Navigate to passenger_home
                                String lid = jasondata['lid'].toString();
                                sh.setString("lid", lid);
                                sh.setString("username", Uname);
                                print(lid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => userhome()),
                                );
                                // Remove the following line that navigates back to the login page
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                                print("++++++++++Ambulance++++++++++");
                              }

                              // } else if (status == "user") {
                              //   String lid = jasondata['lid'].toString();
                              //   sh.setString("lid", lid);
                              //   print(lid);
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => passenger_home()));
                              //   print("=========User==========");
                              // }
                              else {
                                // Invalid username or password
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Invalid username or password.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
