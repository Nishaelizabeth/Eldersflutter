import 'package:elders_flutter/view_request_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat.dart';

class view_extra_work extends StatefulWidget {
  final String Request_id;
  view_extra_work({required this.Request_id});
  @override
  _view_extra_workPageState createState() => _view_extra_workPageState();
}

class _view_extra_workPageState extends State<view_extra_work> {
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
      String categoryUrl = ip! + "/api/view_extra_work";

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid, 'Request_id': widget.Request_id});

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
          title: Text("Extra Work"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),



            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String request = requestController.text;
                final pref = await SharedPreferences.getInstance();
                String lid = pref.getString("lid").toString();
                String Request_id = messageData[index]['Request_id'].toString();
                final Extraamount = messageData[index]['Extraamount'];
                ip = pref.getString("url") ?? "";
                String categoryUrl = ip! + "/api/confirm_amount";

                var data = await http.post(
                  Uri.parse(categoryUrl),
                  body: {
                    'lid': lid,
                    'request': request,
                    'Request_id': Request_id,
                    'Extraamount':Extraamount,

                  },
                );

                var jsonData = json.decode(data.body);
                status = jsonData['status'];
                if (status == "true") {
                  setState(() {
                    messageData = List<Map<String, dynamic>>.from(jsonData['data']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => view_request_user()),
                    );
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => view_request_user()),
                  );

                  // Handle error status if needed
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => view_request_user()),
                );
              },
              child: Text("Confirm Amount"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => view_request_user()),
                );
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
          child: Text('More Items Click Me'),
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
                  final Works = messageData[index]['Works'];
                  final Extraamount = messageData[index]['Extraamount'];
                  final Status = messageData[index]['Status'];

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
                              "Works: $Works",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Extraamount: $Extraamount",
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
