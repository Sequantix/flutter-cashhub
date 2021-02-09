import 'dart:async';
import 'package:flutter/material.dart';
class perium_1 extends StatefulWidget {
  @override
  _perium_1State createState() => _perium_1State();
}

class _perium_1State extends State<perium_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,
              color: Colors.black,
              size: 30,),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Mainpage');

            },
          ),
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text('Basic AppBar'),
            ]
        ),
        actions: <Widget>[

          // IconButton(
          //   icon: Icon(Icons.more_vert,
          //     color: Colors.black,
          //     size: 30,),
          //   onPressed: () {
          //     print('Click start');
          //   },
          // ),
        ],

      ),
body: Container(
    child: Image.asset('assets/premium.png')),

    );

  }
}