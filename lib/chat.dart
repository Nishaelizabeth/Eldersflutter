import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final int senderId;
  final String messageContent;

  Message({required this.senderId, required this.messageContent});
}

class ChatPage extends StatefulWidget {
  final String? caregiverId;

  ChatPage({Key? key, this.caregiverId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  TextEditingController messageController = TextEditingController();
  late String loginId;

  @override
  void initState() {
    super.initState();
    loadLoginId();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Trigger the initial load of messages
      _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> _handleRefresh() async {
    await loadMessages();
  }

  Future<void> loadLoginId() async {
    final pref = await SharedPreferences.getInstance();
    String lid = pref.getString("lid").toString();
    setState(() {
      loginId = lid;
    });
  }

  Future<void> loadMessages() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url") ?? "";
      String categoryUrl = ip + "/api/chat_tech"; // Update to the correct endpoint

      var data = await http.post(Uri.parse(categoryUrl), body: {'lid': lid, 'caregiverId': widget.caregiverId.toString()});

      var jsonData = json.decode(data.body);
      String status = jsonData['status'];

      if (status == "true") {
        setState(() {
          messages = List<Message>.from(jsonData['data'].map((message) => Message(
            senderId: message['Sender_id'],
            messageContent: message['Message'],
          )));
        });
      } else {
        // Handle error status if needed
      }
    } catch (e) {
      print("Error: $e");
      // Handle any errors that occur during the HTTP request.
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String lid = pref.getString("lid").toString();
      String ip = pref.getString("url") ?? "";
      String sendMessageUrl = ip + "/api/send_message"; // Update to the correct endpoint

      var response = await http.post(
        Uri.parse(sendMessageUrl),
        body: {
          'lid': lid,
          'caregiverId': widget.caregiverId.toString(),
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        // Message sent successfully, update UI or handle response if needed
        print('Message sent successfully');
        // Reload messages after sending a new message
        loadMessages();
      } else {
        // Handle error status if needed
        print('Error sending message: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Messages"),
      ),
      body: WillPopScope(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 70), // Adjust bottom padding to accommodate the input field
                    itemBuilder: (context, index) {
                      final isSender = (messages[index].senderId == int.parse(loginId));

                      return Container(
                        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isSender ? Colors.blue[200] : Colors.grey.shade200,
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(messages[index].messageContent, style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 70, // Set a fixed height for the input field section
                padding: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        style: TextStyle(fontSize: 16.0), // Adjust font size
                      ),
                    ),
                    SizedBox(width: 8.0), // Add some space between TextField and IconButton
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        String message = messageController.text.trim();
                        if (message.isNotEmpty) {
                          sendMessage(message);
                          messageController.clear();
                        }
                      },
                      color: Colors.blue, // Change icon color
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
      ),
    );
  }
}
