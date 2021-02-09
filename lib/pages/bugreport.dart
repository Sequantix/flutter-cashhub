import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';

class bugreport extends StatefulWidget {
  @override
  _bugreportState createState() => _bugreportState();
}

class _bugreportState extends State<bugreport> {

  TextEditingController uname = new TextEditingController();
  TextEditingController emailid = new TextEditingController();
  TextEditingController problm = new TextEditingController();

  void mailess(String uname, String emailid, String problm) async{
    String username = 'cashhub42@gmail.com';//Your Email;
    String password = 'cashhub.sam';//Your Email's password;

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('cashhubusa@gmail.com') //recipent email
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject = 'Problem from cashhub app ${DateTime.now()}' //subject of the email
      ..text ='Name: ${uname} \n Email: ${emailid} \n Problem: ${problm}' ;//body of the email

    try {
      final sendReport = await send(message, smtpServer);
      Fluttertoast.showToast(
          msg: "Report has been submitted Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      print('Message sent: ' + sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      Fluttertoast.showToast(
          msg: "Please try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      print('Message not sent. \n'+ e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
    cleartext();
  }

  void cleartext() {
    uname.clear();
    emailid.clear();
    problm.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
      body:
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10,10,10,0),

          child: Column(
              children:<Widget>[
                Row(
                    children:<Widget>[
                      Text('Report',
                          style:  TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(width: 8),
                      Text('Problem',
                          style:  TextStyle(
                            color: Colors.orange,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                SizedBox(height: 30),
                Column(
                  children: [
                    Container(
                     // width: 340,
                      height: 50,
                      child: TextFormField(
                        controller: uname,

                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                           // prefixIcon: Icon(Icons.account_circle),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey),
                            labelText: "Full Name",
                            hintText: "e.g. John Wick",
                            //fillColor: Colors.grey[300]
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      //width: 340,
                      height: 50,
                      child: TextFormField(
                        controller: emailid,

                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                           // prefixIcon: Icon(Icons.account_circle),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey),
                            labelText: "E-mail id",
                            hintText: "e.g. abc@domain.com",
                            //fillColor: Colors.grey[300]
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      // width: 340,
                      // height: 50,
                      child: TextFormField(
                        controller: problm,
                        minLines: 12, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                  color: Colors.green, width: 2),
                            ),
                            //prefixIcon: Icon(Icons.account_circle),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            //filled: true,
                            hintStyle: new TextStyle(color: Colors.grey),
                            labelText: "Describe the problem",

                            fillColor: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),

                    SizedBox(height: 40),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ButtonTheme(
                          minWidth: 150.0,
                          height: 100.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text("Report",
                              style: TextStyle(fontSize: 20),),
                            onPressed: ()async {
                              //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                              // onPressed: ()async {
                              //
                              mailess(uname.text.toString(),emailid.text.toString(),problm.text.toString());
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                          )),
                    ),
                  ],
                ),


              ),
        ),
      );

  }
}
