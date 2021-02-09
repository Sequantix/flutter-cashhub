

import 'package:cashhub/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cashhub/services/datasentService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class details extends StatefulWidget {
  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  Map data = {};
  double TDiscount=0.0;
  Timer _timer;
  int _start = 20;
  String actid;


  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DatasentService _datasentService;

  //adssection
  // TODO: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady;


  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  // TODO: Implement _onInterstitialAdEvent()
  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        _interstitialAd.show();
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        Navigator.of(context).pushNamed('/Mainpage');
        print("ad closed");
        break;
      default:
      // do nothing
    }
  }


//adssection ends
  getfname() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    actid=prefs.getString('actidd');
    print(actid);

  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  Future<DatasentService> getdataSer() async {
    //print(data['items']);
   // Dialogs.showLoadingDialog(context, _keyLoader);
    final bytes = data['imagess'].readAsBytesSync();
    String blobimg = base64Encode(bytes);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    int intValue  = prefs.getInt('intuserId');

    final http.Response response = await http.post(
      'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/AddData',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'MerchantName': data['CompanyName'],
        'TransactionDate':data['TDate'],
        'Tax':data['Tax'],
        'Total':data['Total'],
        'userId':intValue,
        'items':data['items'].toList(),
        'discount':TDiscount.toString(),
        'BlobImage':blobimg,
        'blogname':data['imagename'],

      }),
    );


    print(response.body);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      //print(responseString);
      return datasentServiceFromJson(responseString);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to Save. Please Try again..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
    }
  }

  checkdata() {

    if ( _datasentService.status == "true") {
      //print("success to go");
     // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Fluttertoast.showToast(
          msg: "Saved Succefully..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      actid=="3"?
      Navigator.of(context).pushReplacementNamed('/Mainpage'):
      _loadInterstitialAd();
      // Navigator.of(context).pushReplacementNamed('/Mainpage');

    } else {
      //print("failed to go");
      //Navigator.of(context).pushReplacementNamed('/Mainpage');
     // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Fluttertoast.showToast(
          msg: "Failed to save try again..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
  }
  Widget failedsave(){
    Text('Something went wrong please try again!',
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {

      data = ModalRoute.of(context).settings.arguments;
      //print(data);
      if(data['saveaction']=="1"){
        checksaves();
        startTimer();
      }
      // else{
      //   getImage(ImageSource.gallery);
      // }
    });
    getfname();
    //adsinit
    _isInterstitialAdReady = false;

    // TODO: Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      // adUnitId: 'ca-app-pub-6857391469887868/9102752210',
      listener: _onInterstitialAdEvent,
    );

    //adsinit ends
  }
checksaves() async{
  final DatasentService dataserv = await getdataSer();

  setState(() {
    setState(() {
      _datasentService = dataserv;
    });
  });
  checkdata();
}
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
for(int j=0;j<data['items'].length;j++){

  if(data['items'][j].discount.toString()!=""){
    var dd=double.parse(data['items'][j].discount.toString());
    // Tdds+=dd;
    TDiscount +=dd;
  }

}

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/Mainpage');
            },
          ),
        ),
        title:
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Basic AppBar'),
        ]),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Colors.black,
          //     size: 30,
          //   ),
          //   onPressed: () {
          //     print('Click start');
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
          child: Column(
            children: <Widget>[
              // Row(children: <Widget>[
              //   Text('Receipt',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold,
              //       )),
              //   SizedBox(width: 8),
              //   Text('Details',
              //       style: TextStyle(
              //         color: Colors.orange,
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold,
              //       )),
              // ]),
              SizedBox(height: 300),
              Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    Text('Please Do Not hit back button we are processing your request.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                      Text('This page will be automatically redirected in $_start Seconds..',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),

                    ],
                  ),
                ),
              ),
              // Container(
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text('Store',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               )),
              //           Text(
              //             data['CompanyName'],
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 19,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             textAlign: TextAlign.right,
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 20),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Transaction Date',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 19,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(data['TDate'],
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.right),
              //         ],
              //       ),
              //       SizedBox(height: 20),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Tax',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 19,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text("\$"+ data['Tax'],
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.right),
              //         ],
              //       ),
              //       SizedBox(height: 20),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text('Discount',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               )),
              //           Text("\$"+
              //               TDiscount.toString(),
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 19,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             textAlign: TextAlign.right,
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 20),
              //
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text('SubTotal',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               )),
              //           Text("\$"+
              //               data['Total'],
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 19,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             textAlign: TextAlign.right,
              //           ),
              //         ],
              //       ),
              //
              //       SizedBox(height: 30),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text('Product',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.left),
              //           Text('SKU',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.center),
              //           Text('Price',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //               textAlign: TextAlign.right),
              //
              //         ],
              //       ),
              //
              //       SizedBox(height: 20),
              //       Column(
              //         children: [
              //           for (int i = 0; i < data['items'].length; i++)
              //             Padding(
              //               padding: const EdgeInsets.only(top: 20),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Expanded(
              //                     flex: 1,
              //                     child: Align(
              //                       alignment: Alignment.centerLeft,
              //                       child:
              //                       Text(data['items'][i].itemname.toString(),
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 19,
              //                             fontWeight: FontWeight.bold,
              //                           )),
              //                     ),
              //                   ),
              //                   Expanded(
              //                     flex: 1,
              //                     child: Align(
              //                       alignment: Alignment.center,
              //                       child: Text(data['items'][i].sku.toString(),
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 19,
              //                             fontWeight: FontWeight.bold,
              //                           )),
              //                     ),
              //                   ),
              //                   Expanded(
              //                     flex: 1,
              //                     child: Align(
              //                       alignment: Alignment.centerRight,
              //                       child: Text(
              //                           "\$"+data['items'][i].price.toString(),
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 19,
              //                             fontWeight: FontWeight.bold,
              //                           )),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 40,
              //       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //       child: ButtonTheme(
              //           minWidth: 150.0,
              //           height: 100.0,
              //           child: RaisedButton(
              //             textColor: Colors.white,
              //             color: Colors.green,
              //             child: Text(
              //               "Save",
              //               style: TextStyle(fontSize: 20),
              //             ),
              //             onPressed: () async{
              //               //Navigator.of(context).pushReplacementNamed('/HomeScreen');
              //               // onPressed: ()async {
              //               //
              //               final DatasentService dataserv = await getdataSer();
              //
              //               setState(() {
              //                 setState(() {
              //                   _datasentService = dataserv;
              //                 });
              //               });
              //               checkdata();
              //             },
              //             shape: new RoundedRectangleBorder(
              //               borderRadius: new BorderRadius.circular(8.0),
              //             ),
              //           )),
              //     ),
              //     Container(
              //       height: 40,
              //       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              //       child: ButtonTheme(
              //           minWidth: 150.0,
              //           height: 100.0,
              //           child: RaisedButton(
              //             textColor: Colors.white,
              //             color: Colors.orange,
              //             child: Text(
              //               "Cancel",
              //               style: TextStyle(fontSize: 20),
              //             ),
              //             onPressed: () {
              //               Navigator.of(context).pushReplacementNamed('/Mainpage');
              //             },
              //             shape: new RoundedRectangleBorder(
              //               borderRadius: new BorderRadius.circular(8.0),
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
