import 'dart:convert';
import 'package:elders_flutter/user_home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';




class complaint extends StatefulWidget {


  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<complaint> {
  final TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      String categoryUrl = ip! + "/api/view_complaint";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: feedbackController,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Complaint';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Complaint',
                      hintText: 'Enter your Complaint here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final sh = await SharedPreferences.getInstance();
                        String lid =
                            (await SharedPreferences.getInstance())
                                .getString("lid")
                                ?.toString() ?? '';
                        print(lid);
                        String feedback = feedbackController.text.toString();

                        String url = sh.getString("url").toString();

                        var data = await http.post(
                          Uri.parse(url + "/api/send_complaint"),
                          body: {
                            'name': feedback,
                            'lid': lid,

                          },
                        );

                        var jasondata = json.decode(data.body);
                        String status = jasondata['status'].toString();

                        if (status == "true") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => userhome()),
                          );
                        } else {
                          print("error======");
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thank You!'),
                              content: Text('Your Complaint has been submitted.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Submit Complaint'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Complaint:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messageData.length,
                itemBuilder: (BuildContext context, int index) {
                  final Complaint = messageData[index]['Complaint'];
                  final Reply = messageData[index]['Reply'];
                  final date = messageData[index]['Date'];



                  return GestureDetector(
                    onTap: () {
                      // _showDetailsPopup(index);
                    },
                    child: Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column for the image

                            // Right column for the content
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 10),
                                    Text(
                                      "Complaint: $Complaint",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Reply: $Reply",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Date: $date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Add more content as needed
                                  ],
                                ),
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
