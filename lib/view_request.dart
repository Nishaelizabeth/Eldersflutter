import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class view_request extends StatefulWidget {
  @override
  _ViewRequestPageState createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<view_request> {
  List<Map<String, dynamic>> messageData = [];
  String? ip;
  String? status;
  late String ordermaster_id;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();

      ip = pref.getString("url") ?? "";
      String categoryUrl = ip! + "/api/view_request";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid});

      var jsonData = json.decode(data.body);
      status = jsonData['status'];
      if (status == "true") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle any errors that occur during the HTTP request.
    }
  }
  Future<void> loadMessages2() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();

      ip = pref.getString("url") ?? "";
      String categoryUrl = ip! + "/api/view_request";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid});

      var jsonData = json.decode(data.body);
      status = jsonData['status'];
      if (status == "true") {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle any errors that occur during the HTTP request.
    }
  }
  void _showOrderDetailsDialog(String fname, String details, String amount, int index) {
    TextEditingController requestController = TextEditingController();
    TextEditingController totalAmountController = TextEditingController(); // Add text field controller for total amount
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Care Giver: $fname"),
              Text("Details: $details"),
              Text("Amount: $amount"),
              SizedBox(height: 10), // Add space between existing content and text fields
              TextField(
                controller: requestController,
                decoration: InputDecoration(
                  labelText: 'Enter your request',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10), // Add space between text fields
              TextField(
                controller: totalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter total amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String request = requestController.text;
                String totalAmount = totalAmountController.text; // Retrieve total amount
                final pref = await SharedPreferences.getInstance();
                String lid = pref.getString("lid").toString();
                String Wdetails_id = messageData[index]['Wdetails_id'].toString();
                ip = pref.getString("url") ?? "";
                String categoryUrl = ip! + "/api/send_request";

                var data = await http.post(
                  Uri.parse(categoryUrl),
                  body: {
                    'lid': lid,
                    'request': request,
                    'Wdetails_id': Wdetails_id,
                    'total_amount': totalAmount, // Include total amount in the request body
                  },
                );

                var jsonData = json.decode(data.body);
                status = jsonData['status'];
                if (status == "true") {
                  setState(() {
                    messageData = List<Map<String, dynamic>>.from(jsonData['data']);
                  });
                } else {
                  // Handle error status if needed
                }

                Navigator.of(context).pop(); // Close the dialog after sending request
              },
              child: Text("Send Request"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text('Request'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final fname = messageData[index]['Fname'];
                  final details = messageData[index]['Details'];
                  final amount = messageData[index]['amount'];
                  return GestureDetector(
                    onTap: () {
                      _showOrderDetailsDialog(fname, details, amount, index);
                    },
                    child: Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Care Giver: $fname",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Details: $details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Amount: $amount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
