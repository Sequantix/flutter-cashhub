import 'dart:io';
import 'package:cashhub/ad_manager.dart';
import 'package:cashhub/services/HomeService.dart';
import 'package:cashhub/services/HomePageService.dart';
import 'package:cashhub/services/priceDropService.dart';
import 'package:cron/cron.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
  Pricedrops _pricedrops;
  Homedata _homedata;
  var pdata;
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
  String actid;



  Future<void> main() async {
    final cron = Cron()
      ..schedule(Schedule.parse('01 12 * * *'), () {
        _signOut();
      });
    await Future.delayed(Duration(seconds: 20));
    await cron.close();
  }

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
        Navigator.of(context).pushNamed('/search');
        print("ad closed");
        break;
      default:
      // do nothing
    }
  }

//adssection ends

Future<Pricedrops> priceDrops() async{
  final response = await http.get(
      'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/GetPricedrops');

  print(response.body);
  // if (response.statusCode == 200) {
  final String responseString = response.body;

  return pricedropsFromJson(responseString);
  // } else {
  // return null;
  //}
}

  Future<Homedata> getHomeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('userId');
    print(stringValue);
    final response = await http.get(
        'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/GetData/' +
            stringValue);

   // print(response.body);
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
  actid=prefs.getString('actidd');
  print(actid);

}
  void initState() {
    super.initState();
//
// print("test");
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context).settings.arguments;
      demodata();
      pricedrp();
getfname();
      main();
      initOnsignal();
      //getStringValuesSF();
    });

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
pricedrp() async{
    final Pricedrops prdrp = await priceDrops();
    setState(() {
      setState(() {
        _pricedrops = prdrp;
      });
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
              title: Text("Contact Us"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Upgrade to Premium"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/perim1');
              },
            ),
            ListTile(
              title: Text("Report a Problem"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/reportbug');
                //Navigator.of(context).pop();
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
            ),

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
                  //Navigator.of(context).pushReplacementNamed('/Mimages');
//pop
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 16,
                        child: Container(
                          height: 230.0,
                          width: 330.0,
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: 20),
                              //Center(
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Add a Receipt",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ),
                              SizedBox(height: 20),
                              FlatButton(
                                child: Text(
                                  'Take a photo..',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  // Navigator.of(context).pushReplacementNamed('/edgedetec');
                                  Navigator.pushReplacementNamed(
                                      context, '/crop',
                                      arguments: {
                                        'pickerCode': "0",
                                      });
                                  //Navigator.of(context).pop();

                                  // picker.getImage(ImageSource.camera);
                                },
                                textColor: Colors.black,
                              ),
                              FlatButton(
                                child: Text(
                                  'Choose from Library..',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/crop',
                                      arguments: {
                                        'pickerCode': "1",
                                      });
                                },
                                textColor: Colors.black,
                              ),
                              FlatButton(
                                child: Text(
                                  'Click to add long Receipt..',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed('/Mimages');
                                  //Navigator.of(context).pop();

                                  // picker.getImage(ImageSource.camera);
                                },
                                textColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  //pop ends
                },
              ),
              SizedBox(width: 90),
              GestureDetector(
                  onTap: () {
                    actid=="3"?
                    Navigator.of(context).pushNamed('/search'):
                    _loadInterstitialAd();
                    //Navigator.of(context).pushNamed('/search');
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
                Text('Price Drops',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  height: 1,
                  color: Colors.grey[500],
                  child: Text('sadfafrtretertertertewewewewewewekhhhh'),
                ),
              ]),
            ),
            SizedBox(height: 10),
            _pricedrops == null
                ? Container()
                : actid=="3"?
            Column(
              children: [
                //if((_homedata.products).length>0)
                // for (int i = 0; i <_homedata.products.length; i++)

               for (int i = 0; i <2; i++)
               // for (int i = 0; i <_pricedrops.data.length; i++)
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
                                      Icons.trending_down,
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
                                              (_pricedrops.data[i].merName)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text(
                                              (_pricedrops.data[i].proName)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          SizedBox(height: 6,),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_offer,
                                                size: 15,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 6,),
                                              Text(
                                                  "Original Price    \$" +
                                                      (_pricedrops.data[i].lastPrice)
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          SizedBox(height: 6,),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.notifications,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 6,),
                                              Text(
                                                  "Notification       \$" +
                                                      (_pricedrops.data[i].currentPrice)
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
    //                             Expanded(
    //                                 flex: 1,
    //                                 child: GestureDetector(
    // onTap: () {
    //   Navigator.pushReplacementNamed(
    //       context, '/hdetails',
    //       arguments: {
    //         'Storeid': _homedata.products[i].mid,
    //       });
    // },
    //                                   child: Icon(
    //                                     Icons.arrow_forward_ios,
    //                                     size: 30,
    //
    //                                   ),
    //                                 ),
    //                             ),
                              ],
                            ),
                          ),
                        ),
              ],
            ): Column(
              children: [
                //if((_homedata.products).length>0)
                // for (int i = 0; i <_homedata.products.length; i++)

                for (int i = 0; i <_pricedrops.data.length; i++)
                // for (int i = 0; i <_pricedrops.data.length; i++)
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
                                Icons.trending_down,
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
                                        ("Upgrade to Premium to view the vendor")
                                            .toString(),
                                        style: TextStyle(
                                            // fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),

                                    Text(
                                        (_pricedrops.data[i].proName)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black)),
                                    SizedBox(height: 6,),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer,
                                          size: 15,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 6,),
                                        Text(
                                            "Original Price    \$" +
                                                (_pricedrops.data[i].lastPrice)
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    SizedBox(height: 6,),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          size: 17,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 6,),
                                        Text(
                                            "Notification       \$" +
                                                (_pricedrops.data[i].currentPrice)
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          //                             Expanded(
                          //                                 flex: 1,
                          //                                 child: GestureDetector(
                          // onTap: () {
                          //   Navigator.pushReplacementNamed(
                          //       context, '/hdetails',
                          //       arguments: {
                          //         'Storeid': _homedata.products[i].mid,
                          //       });
                          // },
                          //                                   child: Icon(
                          //                                     Icons.arrow_forward_ios,
                          //                                     size: 30,
                          //
                          //                                   ),
                          //                                 ),
                          //                             ),
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
