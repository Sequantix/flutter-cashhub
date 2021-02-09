import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cashhub/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Map data = {};
  String _output='';
  String _body='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initOnsignal();
  }
  Future <void>  initOnsignal() async{
   await OneSignal.shared.init('3be9d9b7-03cf-47a1-9b65-c3c6c814e60a');
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

   OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
     this.setState(() {
       // _output =
       // "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
       // print(notification.jsonRepresentation());
       _output=notification.payload.title;
       _body=notification.payload.body;
     });
   });
   OneSignal.shared
       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
     this.setState(() {
       // Navigator.of(context).pushNamed('/notifications');
       _output =result.notification.payload.title;
       _body =result.notification.payload.body;

      // "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
     });
   });

  }


  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

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
              //Navigator.pop(context);
              //Navigator.of(context,rootNavigator: true).pop();
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
          //     Navigator.of(context).pushReplacementNamed('/notifications');
          //   },
          // ),
        ],

      ),
    body:
    Container(
    padding: EdgeInsets.fromLTRB(10,10,10,0),
    child: Column(
    children:<Widget>[
      data == null ?
      Container(
        padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
        //child:SizedBox(height: 10,),
        child:Center(child: Text("No new Notifications")),
      ):
      Card(
        margin: EdgeInsets.all(12),
        elevation: 8,
        //color: Color.fromRGBO(64, 75, 96, .9),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),

          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(Icons.local_offer, size: 30,color: Colors.green,)),
              SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Row(
                  children: <Widget>[

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Text( data['Title'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.trending_down,color: Colors.green, size:15),
                            SizedBox(width: 10),

                            Text( data['Body'], style: TextStyle(color: Colors.black)),
                            SizedBox(width: 20),
                            // Text("\$55", style: TextStyle(color: Colors.black,
                            // fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     Icon(Icons.trending_down,color: Colors.red, size:20),
                        //     SizedBox(width: 10),
                        //     Text("Notification", style: TextStyle(color: Colors.black)),
                        //     SizedBox(width: 25),
                        //     Text("\$52", style: TextStyle(color: Colors.black,
                        //         fontWeight: FontWeight.bold)),
                        //   ],
                        // ),
                      ],
                    ),

                  ],
                ),
              ),
              // Expanded(
              //     flex: 1,
              //     child: Icon(Icons.arrow_forward_ios, size: 30,)),
            ],
          ),
        ),
      ),
data==null?
      Container():
    Container(padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
    child: Text('Notifications will be deleted automatically after viewing!'),
    ),
      //second card

      ]),
    ),
    );
  }
}
