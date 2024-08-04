import 'package:elders_flutter/ecompliant.dart';
import 'package:elders_flutter/payment.dart';
import 'package:elders_flutter/rate.dart';
import 'package:elders_flutter/view_extra_work.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat.dart';

class view_request_user extends StatefulWidget {
  @override
  _view_request_userPageState createState() => _view_request_userPageState();
}

class _view_request_userPageState extends State<view_request_user> {
  List<Map<String, dynamic>> messageData = [];
  String? ip;
  String? status;

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
      String categoryUrl = ip! + "/api/view_request_user";

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

  void _showOrderDetailsDialog(int index) {
    TextEditingController requestController = TextEditingController();
    TextEditingController totalAmountController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [


              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to chat page with Caregiver_id
                  String caregiverId = messageData[index]['Caregiver_id'].toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage(caregiverId: caregiverId)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.chat), // Text chat icon
                    SizedBox(width: 10),
                    Text("Text Chat"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  String Request_id = messageData[index]['Request_id'].toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => view_extra_work(Request_id: Request_id)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.work), // Text chat icon
                    SizedBox(width: 10),
                    Text("Extra Work"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  String Request_id = messageData[index]['Request_id'].toString();
                  String Total = messageData[index]['Total'].toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentForm(Request_id: Request_id,Total:Total)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.payment), // Text chat icon
                    SizedBox(width: 10),
                    Text("Make Payment"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  String Request_id = messageData[index]['Request_id'].toString();
                  String Total = messageData[index]['Total'].toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ecomplaint(Request_id: Request_id)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.report_problem), // Text chat icon
                    SizedBox(width: 10),
                    Text("Any faults / misbehave "),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  String Request_id = messageData[index]['Request_id'].toString();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pass_rating(Request_id: Request_id)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.star_rate), // Text chat icon
                    SizedBox(width: 10),
                    Text("Rate"),
                  ],
                ),

              ),
              SizedBox(height: 10),
              TextField(
                controller: requestController,
                decoration: InputDecoration(
                  labelText: 'Enter Informations',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () async {
                String request = requestController.text;
                final pref = await SharedPreferences.getInstance();
                String lid = pref.getString("lid").toString();
                String Request_id = messageData[index]['Request_id'].toString();
                ip = pref.getString("url") ?? "";
                String categoryUrl = ip! + "/api/send_info";

                var data = await http.post(
                  Uri.parse(categoryUrl),
                  body: {
                    'lid': lid,
                    'request': request,
                    'Request_id': Request_id,

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

                Navigator.of(context).pop();
              },
              child: Text("Send Info"),
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
          child: Text('Request Details'),
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
                  final Details = messageData[index]['Details'];
                  final Date = messageData[index]['Date'];
                  final Time = messageData[index]['Time'];
                  final Total=messageData[index]['Total'];
                  final Status=messageData[index]['Status'];
                  return GestureDetector(
                    onTap: () {
                      _showOrderDetailsDialog(index);
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
                              "Details: $Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Date: $Date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Time: $Time",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Amount: $Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Status: $Status",
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
