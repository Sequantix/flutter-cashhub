

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

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DatasentService _datasentService;

  Future<DatasentService> getdataSer() async {
    //print(data['items']);
    Dialogs.showLoadingDialog(context, _keyLoader);
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
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Fluttertoast.showToast(
          msg: "Saved Succefully..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      Navigator.of(context).pushReplacementNamed('/Mainpage');

    } else {
      //print("failed to go");
      //Navigator.of(context).pushReplacementNamed('/Mainpage');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Fluttertoast.showToast(
          msg: "Failed to save try again..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
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
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              print('Click start');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Text('Receipt',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(width: 8),
                Text('Details',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
              SizedBox(height: 30),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Store',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          data['CompanyName'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(data['TDate'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("\$"+ data['Tax'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("\$"+
                            TDiscount.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SubTotal',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("\$"+
                            data['Total'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left),
                        Text('SKU',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center),
                        Text('Price',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right),

                      ],
                    ),

                    SizedBox(height: 20),
                    Column(
                      children: [
                        for (int i = 0; i < data['items'].length; i++)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child:
                                    Text(data['items'][i].itemName.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(data['items'][i].sku.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "\$"+data['items'][i].totalPrice.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ButtonTheme(
                        minWidth: 150.0,
                        height: 100.0,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async{
                            //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                            // onPressed: ()async {
                            //
                            final DatasentService dataserv = await getdataSer();

                            setState(() {
                              setState(() {
                                _datasentService = dataserv;
                              });
                            });
                            checkdata();
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                        )),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ButtonTheme(
                        minWidth: 150.0,
                        height: 100.0,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.orange,
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/Mainpage');
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
