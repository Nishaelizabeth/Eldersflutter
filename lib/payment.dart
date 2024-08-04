import 'dart:convert';

import 'package:elders_flutter/user_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class PaymentForm extends StatefulWidget {
  final dynamic Total;
  final String Request_id;

  PaymentForm({
    required this.Total,
    required this.Request_id,
  });

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool showMessage = false;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController amountController=TextEditingController();
  @override
  void initState() {
    super.initState();

    // Set the rate value in the amount field when the widget is initialized
    amountController.text = widget.Total.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: cardNumberController,
              decoration: InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              enabled: false,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: expirationDateController,
                    decoration: InputDecoration(labelText: 'Expiration Date'),
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cvvController,
                    decoration: InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            if (showMessage)
              Text('You have already paid for this month.',style: TextStyle(color: Colors.red)),



            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {

                // TODO: Add payment processing logic here
                _processPayment1();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userhome(),
                  ),
                );// _processPayment1();
                // _processPayment();
              },
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment1() async {
    final sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();
    String Request_id = widget.Request_id;


    // Fetch date information from the database


    // Continue with the payment request
    var paymentResponse = await http.post(
      Uri.parse(url + "/api/payment"),
      body: {
        'amount': amountController.text,
        'Request_id': Request_id,
        'lid': lid,
      },
    );

    var paymentJson = json.decode(paymentResponse.body);
    String paymentStatus = paymentJson['status'].toString();

    if (paymentStatus == "true") {
      // Payment successful, handle accordingly
      print('Payment Successful!');

    } else {
      // Payment failed, handle accordingly
      print('Payment Failed: ${paymentJson['message']}');

    }




  }




  @override
  void dispose() {
    cardNumberController.dispose();
    expirationDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}

// void main() {
//   // runApp(MaterialApp(
//   //   home: PaymentForm(rate: 'rate',),
//   ));
// }
