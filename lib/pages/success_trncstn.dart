import 'package:flutter/material.dart';

class Tnsucess extends StatefulWidget {
  @override
  _TnsucessState createState() => _TnsucessState();
}

class _TnsucessState extends State<Tnsucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Expanded(
            child:
                Center(
                  child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 140,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              'Success',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                ),


          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,20,20),
            child: Container(
              alignment: Alignment.bottomRight,
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ButtonTheme(
                  minWidth: 140.0,
                  height: 45.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.orange,
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pushReplacementNamed('/Mainpage');
                    },

                    shape: new RoundedRectangleBorder(
                      borderRadius:
                      new BorderRadius.circular(30.0),
                    ),
                  )),
            ),
          )
        ],

      ),
    );
  }
}
