import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';




void main() {
  runApp(const ipsetting());
}

class ipsetting extends StatefulWidget {
  const ipsetting({super.key});

  @override
  State<ipsetting> createState() => _plastic_State();
}

class _plastic_State extends State<ipsetting> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const ipset(),
    );
  }
}

class ipset extends StatefulWidget {
  const ipset({super.key});

  @override
  State<ipset> createState() => _ipsetstate();
}

class _ipsetstate extends State<ipset> {
  final TextEditingController ipController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a global key for the form

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Elders Helping System "),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                // Background image
                // Image.asset(
                //   'assets/ip.jpg',
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                //   height: double.infinity,
                // ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: TextFormField(
                          controller: ipController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "IP Address",
                            hintText: "Enter a valid IP address",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the IP';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              print("Not validated");
                            } else {
                              String ip = ipController.text.toString();
                              final sh = await SharedPreferences.getInstance();
                              sh.setString("url", "http://" + ip);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()));
                            }
                          },
                          child: const Icon(Icons.key),
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
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
    );
  }
}
