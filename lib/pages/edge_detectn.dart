
import 'dart:io';

// import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Edge_Det extends StatefulWidget {
  @override
  _Edge_DetState createState() => _Edge_DetState();
}

class _Edge_DetState extends State<Edge_Det> {
  String _imagePath = 'Unknown';
  File img;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String imagePath;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // imagePath = await EdgeDetection.detectEdge;
      // img = (await EdgeDetection.detectEdge) as File;
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          // child: new Text('Cropped image path: $_imagePath\n'),
            child:Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_imagePath))
                    )
                )
            ),
        ),
      );

  }
}
