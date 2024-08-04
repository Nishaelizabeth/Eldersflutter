import 'package:flutter/material.dart';

import 'drawer.dart';

void main() {
  runApp(userhome());
}

class userhome extends StatelessWidget { @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Elders Helping System'),
      ),
      drawer: Drawerclass(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: HorizontalCardScroll(),
          ),
          // Positioned(
          //   top: 50.0,
          //   left: 30.0,
          //   child: Text(
          //     "Welcome To Elders Helping System ",
          //
          //     style: TextStyle(
          //
          //       fontSize: 29.0, // Adjust the font size as needed
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black, // Adjust the color as needed
          //     ),
          //   ),
          // ),
        ],
      ),
    ),
  );
}
}


class HorizontalCardScroll extends StatelessWidget {
  final List<String> images = [
    'assets/elder_1.jpg',
    'assets/elder_2.png',
    'assets/elder_3.jpeg',
    'assets/elder_4.jpeg',
    // Add more image paths as needed
  ];

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height / 3;

    return Container(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: 399,
                height: cardHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
