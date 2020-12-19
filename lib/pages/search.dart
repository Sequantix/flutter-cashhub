import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cashhub/services/SearchServiceAzure.dart';
import 'package:flutter/material.dart';
import 'package:cashhub/main.dart';
import 'package:cashhub/pages/loader.dart';

class searchw extends StatefulWidget {
  @override
  _searchwState createState() => _searchwState();


}

class _searchwState extends State<searchw> {

  SearchService  _searchService;
  bool previSerch=false;
  TextEditingController Searchbox = new TextEditingController();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();


  Future<SearchService> getsearchResults(String search) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    final http.Response response = await http.get(
      'https://cashhub-ss-dev.search.windows.net/indexes/azuresql-index/docs?api-version=2020-06-30&search='+search,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'api-key':'D2F01C35EE85F5DE14703C4262A1C455'
      },

    );

    //print(response.body);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      //print(responseString);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop();
      return searchServiceFromJson(responseString);

    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop();
      Fluttertoast.showToast(
          msg: "Search was not successful, please try again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
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

          IconButton(
            icon: Icon(Icons.more_vert,
              color: Colors.black,
              size: 30,),
            onPressed: () {
              print('Click start');
            },
          ),
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
                      Text('Search',
                          style:  TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(width: 8),
                      Text('Receipt',
                          style:  TextStyle(
                            color: Colors.orange,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You can search items by Date, Store Name, Product Name, SKU Number, UPC Number',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0,0,25,0),
                      child: TextField(
                        controller: Searchbox,
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(color: Colors.green, width: 1),
                            ),
                            prefixIcon: Icon(Icons.search,color: Colors.green,),
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(23.0),
                              ),

                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey),
                            hintText: "search",
                            fillColor: Colors.grey[200]),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ButtonTheme(
                          minWidth: 150.0,
                          height: 100.0,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text("Search",
                              style: TextStyle(fontSize: 20),),
                            onPressed: ()async {
                              //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                              // onPressed: ()async {
                              //
                              final SearchService searcsh = await getsearchResults(
                                  Searchbox.text.toString());


                              setState(() {
                                setState(() {
                                  _searchService = searcsh;
                                });
                              });
                              //checkloginstatus();
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Visibility(
                  visible: _searchService==null?previSerch=false:previSerch=true,
                  child: Row(
                      children:<Widget>[
                        Text('Search Results',
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[500],
                          child: Text('sadfafrtretertertertkhwehrwe'),
                        ),

                      ]),
                ),
                SizedBox(height: 10),

                _searchService == null
                    ? Container():
                Column(
                  children: [
                    for (int i = 0; i <_searchService.value.length; i++)
                    

                     Card(
                        margin: EdgeInsets.all(12),
                        elevation: 8,
                        //color: Color.fromRGBO(64, 75, 96, .9),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.receipt,
                                    size: 30,
                                    color: Colors.green,
                                  )),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                            (_searchService.value[i].merchantName)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text("Saved: \$"+
                                            (_searchService.value[i].discount)
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold)),
                                        // Text(
                                        //     "\$" +
                                        //         (_searchService.value[i].itemName)
                                        //             .toString(),
                                        //     style: TextStyle(
                                        //         color: Colors.black)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/Sdata',
                                        arguments: {
                                          'Storeid': _searchService.value[i].id,
                                        });
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 30,

                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                  ],
                ),
              ]),
        ),
      ),
    );

  }
}
