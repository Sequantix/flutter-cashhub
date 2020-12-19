import 'dart:io';
import 'package:cashhub/services/HomeService.dart';
import 'package:cashhub/services/HomePageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cashhub/main.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  String distotal="0";
  bool previSerch=false;

  Homedata _homedata;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GoogleSignIn _gSignIn =new GoogleSignIn();
  final TwitterLogin twitterLogin = new TwitterLogin(
    consumerKey: 'EVSVqq1Ib4c0Qh5gbetBgMsuU',
    consumerSecret:'mpfgw5I9lS2wyvcMIe9PuAzaUiI9umfSncU2mFGDdtLcJgXjeR',
  );

  Map data = {};
  String _output='';
  String _body='';
  String Mname;
  String Tdate;
  String ItemName;
  String usrName;
  String UsrEmail;

  void _signOut()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    twitterLogin.logOut();
    _gSignIn.signOut();
    _logOut();

  }
  _logOut() async {
    final result =  FacebookAuth.instance;
    await FacebookAuth.instance.logOut();

  }

  Future<Homedata> getHomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('userId');
    print(stringValue);
    final response = await http.get(
        'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/GetData/' +
            stringValue);

    print(response.body);
    // if (response.statusCode == 200) {
    final String responseString = response.body;
    return homedataFromJson(responseString);
    // } else {
    return null;
    //}
  }
getfname() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
   usrName = prefs.getString('UserName');
  UsrEmail=prefs.getString('UserEmails');

}
  void initState() {
    super.initState();
//
// print("test");
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context).settings.arguments;
      demodata();
getfname();
      initOnsignal();
      //getStringValuesSF();
    });
  }

  demodata() async {
    final Homedata homedat = await getHomeData();

    setState(() {
      setState(() {
        _homedata = homedat;
      });
    });
    //getStringValuesSF();
    //Navigator.pushNamed(context, '/details');
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
if(_homedata==null){
  distotal="0";
}else{
  distotal=(_homedata.disoct).toString();
}

    //data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            usrName== null ?
                Container():
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white60,
          ),
          currentAccountPicture: Image.asset("assets/Loginogo.png",
          width: 150,),

        accountName: Text("Hi, "+usrName,
          style: TextStyle(color: Colors.orange ,fontSize: 20)),
        accountEmail: Text(UsrEmail,
            style: TextStyle(color: Colors.black ,)),
        ),

            ListTile(
              title: Text("Help"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Select Plan"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                _signOut();
                Navigator.of(context).pushReplacementNamed('/HomeScreen');
                //Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Rate us"),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        //drawer: Drawer(),
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.grey[500],
              size: 30,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('Basic AppBar'),
        ]),

        actions: <Widget>[
          _output==""?
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.grey[500],
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ):
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: Colors.red,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications',arguments: {
                'Title':(_output),
                'Body':(_body),
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Text('Cash',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Hub',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            SizedBox(height: 60),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              GestureDetector(
                child: Image.asset('assets/Snap.png', height: 90),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/Mimages');

                },
              ),
              SizedBox(width: 90),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/search');
                  },
                  child: Image.asset('assets/search.png', height: 90)),
            ]),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Snap Receipt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(width: 60),
              Text('Search Receipt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/montly.png',
                            height: 40,
                          ),
                          SizedBox(height: 10),
                          Text('Total Saving',
                            style: TextStyle(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[500]),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          children: [
                            // Image.asset(
                            //   'assets/yearly.png',
                            //   height: 40,
                            // ),
                            SizedBox(height: 10),
                            SizedBox(height: 20),
                            Text(
                              distotal +' \$',
                              style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(height: 30),
            Visibility(
              visible: _homedata==null?previSerch=false:previSerch=true,
              child: Row(children: <Widget>[
                Text('Previous Receipts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[500],
                  child: Text('sadfafrtretertertertkhhhh'),
                ),
              ]),
            ),
            SizedBox(height: 10),
            _homedata == null
                ? Container()
                :
            Column(
              children: [
                //if((_homedata.products).length>0)
                for (int i = 0; i <_homedata.products.length; i++)
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
                                              (_homedata.products[i].store)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text(
                                              (_homedata.products[i].tdate)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          Text(
                                              "\$" +
                                                  (_homedata.products[i].pname)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.black)),
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
          context, '/hdetails',
          arguments: {
            'Storeid': _homedata.products[i].mid,
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
            // SizedBox(height: 20,),
            // Card(
            //   margin: EdgeInsets.all(12),
            //   elevation: 8,
            //   //color: Color.fromRGBO(64, 75, 96, .9),
            //
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
            //
            //     child: Row(
            //       children: [
            //         Expanded(
            //             flex: 1,
            //             child: Icon(Icons.watch, size: 30,color: Colors.green,)),
            //         SizedBox(width: 10),
            //         Expanded(
            //           flex: 5,
            //           child: Row(
            //             children: <Widget>[
            //
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: <Widget>[
            //
            //                   Text("25-05-2020", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            //                   SizedBox(height: 4),
            //                   Text("Nike Rise 365 Wild Run", style: TextStyle(color: Colors.black)),
            //                   Text("Nike Store", style: TextStyle(color: Colors.black)),
            //                 ],
            //               ),
            //
            //             ],
            //           ),
            //         ),
            //         Expanded(
            //             flex: 1,
            //             child: Icon(Icons.arrow_forward_ios, size: 30,)),
            //       ],
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }
}
