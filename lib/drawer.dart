
import 'package:elders_flutter/login.dart';
import 'package:elders_flutter/view_request.dart';
import 'package:elders_flutter/view_request_user.dart';
import 'package:flutter/material.dart';

import 'complaint.dart';



class Drawerclass extends StatelessWidget {
  const Drawerclass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              "Elders Helping System",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          ListTile(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.request_page_outlined,
                  size: 30,
                )),
            title: const Text(
              "Request",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => view_request()));
            },
          ),
          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.view_agenda_outlined,
                    size: 30,
                  )),
              title: const Text(
                "view request",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => view_request_user()));
              }
          ),
          ListTile(
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.report_problem_outlined,
                    size: 30,
                  )),
              title: const Text(
                "Complaint",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => complaint()));
              }
          ),
          ListTile(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                )),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login()));
            }
          ),
          // ListTile(
          //   leading: IconButton(
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.message,
          //         size: 30,
          //       )),
          //   title: const Text(
          //     "Chat",
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => view_chat()));
          //   },
          // ),
          // ListTile(
          //     leading: IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.report,
          //           size: 30,
          //         )),
          //     title: const Text(
          //       "Complaint",
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     onTap: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => ComplaintForm()));
          //     }
          // ),
          // ListTile(
          //     leading: IconButton(
          //         onPressed: () {},
          //         icon: const Icon(
          //           Icons.star,
          //           size: 30,
          //         )),
          //     title: const Text(
          //       "Rate",
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     onTap: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => pass_rating()));
          //     }
          // ),
          //
          //
          //
          //
          //
          // ListTile(
          //   leading: IconButton(
          //       onPressed: () {},
          //       icon: const Icon(
          //         Icons.logout,
          //         size: 30,
          //       )),
          //   title: const Text(
          //     "Logout",
          //     style: TextStyle(fontSize: 20),
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => login()));
          //   },
          // ),

        ],
      ),
    );
  }
}
