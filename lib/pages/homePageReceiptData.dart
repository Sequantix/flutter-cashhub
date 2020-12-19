import 'package:cashhub/services/signinapi.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cashhub/services/HomePageService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class hdetails extends StatefulWidget {
  @override
  _hdetailsState createState() => _hdetailsState();
}

class _hdetailsState extends State<hdetails> {
  Map data = {};
  HomePageStore _homePageStore;

  Future<HomePageStore> getStoreData() async {

    //Return String

   // String stringValue = prefs.getString('userId');
 final response = await http.get(
        'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/GetStore/' +
            data['Storeid'].toString());


    print(response.body);
    // if (response.statusCode == 200) {
    final String responseString = response.body;
    return homePageStoreFromJson(responseString);

    // } else {
    return null;
    //}

  }

  fdemodata() async {
    final HomePageStore phomedat = await getStoreData();

    setState(() {
      setState(() {
        _homePageStore = phomedat;
      });
    });
    //getStringValuesSF();
    //Navigator.pushNamed(context, '/details');
  }
  void initState() {
    super.initState();
//
// print("test");
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context).settings.arguments;
      fdemodata();


      //getStringValuesSF();
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Mainpage');
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
      body: _homePageStore==null?Container():SingleChildScrollView(
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
                        Text(_homePageStore==null ? '':_homePageStore.products.mname,
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
                        Text(_homePageStore==null ? '':_homePageStore.products.tdate,
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
                        Text( _homePageStore==null ? '':"\$"+_homePageStore.products.mtax.toString(),
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
                          'Discount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text( _homePageStore==null ? '':"\$"+_homePageStore.products.mdiscount.toString(),
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
                        Text('SubTotal',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(_homePageStore==null ? '':"\$"+_homePageStore.products.mTotal.toString(),
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
                        for (int i = 0; i < _homePageStore.products.itemModels.length; i++)
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
                                    Text(_homePageStore==null ? '':_homePageStore.products.itemModels[i].iName,
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
                                    child: Text(_homePageStore==null ? '':_homePageStore.products.itemModels[i].isku,
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
                                        _homePageStore==null ? '':"\$"+_homePageStore.products.itemModels[i].iPrice,
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

SizedBox(height: 30,),
                    Text('Original Receipt',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left),
                    SizedBox(height: 30,),
                    Image.network(_homePageStore==null ?Container(): _homePageStore.products.mblob,
                    height: 500,
                    width: 500,),
                  ],


                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   height: 40,
                  //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //   child: ButtonTheme(
                  //       minWidth: 150.0,
                  //       height: 100.0,
                  //       child: RaisedButton(
                  //         textColor: Colors.white,
                  //         color: Colors.green,
                  //         child: Text(
                  //           "Save",
                  //           style: TextStyle(fontSize: 20),
                  //         ),
                  //         onPressed: () async{
                  //           //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                  //           // onPressed: ()async {
                  //           //
                  //
                  //         },
                  //         shape: new RoundedRectangleBorder(
                  //           borderRadius: new BorderRadius.circular(8.0),
                  //         ),
                  //       ),
                  //   ),
                  // ),

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
                            "Back",
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
