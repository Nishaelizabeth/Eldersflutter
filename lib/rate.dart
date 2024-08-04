import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class pass_rating extends StatefulWidget {
  @override
  final String Request_id;
  pass_rating({required this.Request_id});
  _rateState createState() => _rateState();
}

class _rateState extends State<pass_rating> {
  double rating = 0.0;
  String review = ''; // Added review variable
  List<Map<String, dynamic>> messageData = [];

  final TextEditingController rate = TextEditingController();
  final TextEditingController reviewController = TextEditingController(); // Controller for the review text field
  final _formKey = GlobalKey<FormState>();

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.cyan),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Elders Helping System"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Rating",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RatingBar(
                      initialRating: rating,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star, color: Colors.amber),
                        half: Icon(Icons.star_half, color: Colors.amber),
                        empty: Icon(Icons.star_border, color: Colors.amber),
                      ),
                      itemSize: 40,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Add TextField for writing review
                    TextFormField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        labelText: 'Write a review',
                        border: outlineBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          review = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          print("Not validated");
                        } else {
                          final sh = await SharedPreferences.getInstance();
                          String name = rate.text.toString();
                          String url = sh.getString("url")?.toString() ?? '';
                          String lid =
                              (await SharedPreferences.getInstance())
                                  .getString("lid")
                                  ?.toString() ?? '';

                          var data = await http.post(
                            Uri.parse(url + "/api/add_rate"),
                            body: {
                              'rate': rating.toString(),
                              'review': review, // Pass the review value
                              'Request_id': widget.Request_id,
                              'login_id': lid ?? '',
                            },
                          );

                          var jsonData = json.decode(data.body);
                          String status = jsonData['status'].toString();

                          if (status == "true") {
                            Navigator.pop(context, true);
                          } else {
                            print("error======");
                          }
                        }
                      },
                      icon: Icon(Icons.send),
                      label: Text('Submit'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: messageData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rated:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                RatingBar(
                                  initialRating: double.parse(messageData[index]['Rated'].toString() ?? '0.0'),
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star, color: Colors.amber),
                                    half: Icon(Icons.star_half, color: Colors.amber),
                                    empty: Icon(Icons.star_border, color: Colors.amber),
                                  ),
                                  itemSize: 40,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  ignoreGestures: true, onRatingUpdate: (double value) {  },
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Review: ${messageData[index]['Review']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Date: ${messageData[index]['Date']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ip = prefs.getString("url") ?? "";
    String lid = prefs.getString("lid").toString();
    String url = ip + "/api/view_rate";

    try {
      final response = await http.post(Uri.parse(url), body: {'login_id': lid,'Request_id': widget.Request_id});
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          messageData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
