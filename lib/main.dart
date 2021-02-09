import 'dart:async';

import 'package:cashhub/ad_manager.dart';
import 'package:cashhub/pages/LogInSignIn.dart';
import 'package:cashhub/pages/bugreport.dart';
import 'package:cashhub/pages/edge_detectn.dart';
import 'package:cashhub/pages/premium_1.dart';
import 'package:flutter/material.dart';
import 'package:cashhub/pages/homescreen.dart';
import 'package:cashhub/pages/search.dart';
import 'package:cashhub/pages/notifications.dart';
import 'package:cashhub/pages/imgpicker.dart';
import 'package:cashhub/pages/details.dart';
import 'package:cashhub/services/local_authentication_service.dart';
import 'package:cashhub/services/service_locator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:cashhub/pages/homePageReceiptData.dart';
import 'package:cashhub/pages/multiimage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashhub/pages/SearchReceiptdata.dart';
import 'package:cashhub/pages/passwordreset.dart';
import 'package:cashhub/pages/otppage.dart';
import 'package:cashhub/pages/passwordupdate.dart';
import 'package:firebase_admob/firebase_admob.dart';
void main() {
  setupLocator();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
       '/HomeScreen': (BuildContext context) => new LogInSignIn(),
      '/Mainpage': (BuildContext context) => new Mainpage(),
      '/search': (BuildContext context) => new searchw(),
      '/notifications': (BuildContext context) => new Notifications(),
      '/crop': (BuildContext context) => new MyHomePage(),
      '/details':(BuildContext context) => new details(),
      '/hdetails':(BuildContext context) => new hdetails(),
      '/Mimages':(BuildContext context) => new SingleImageUpload(),
      '/Sdata':(BuildContext context) => new sdetails(),
      '/resetpassword':(BuildContext context)=> new Passwordreset(),
      '/otppage':(BuildContext context)=> new OtpPage(),
      '/updatepassword':(BuildContext context)=> new updatepassword(),
      '/reportbug':(BuildContext context)=> new bugreport(),
      '/edgedetec':(BuildContext context)=> new Edge_Det(),
      '/perim1':(BuildContext context)=> new perium_1(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _output='';
  String _body='';
  //final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }


  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    // if( message == "Not Authorized"){
    //   SystemNavigator.pop();
    // }
    setState(() {
      _authorized = message;
    });

  }

  void navigationPage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue="";
     stringValue = prefs.getString('userId');
    print(stringValue);
    if(stringValue==null){
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
    }else if(_output !=""){
      Navigator.of(context).pushReplacementNamed('/notifications',arguments: {
        'Title':(_output),
        'Body':(_body),
      });
    }else{
      Navigator.of(context).pushReplacementNamed('/Mainpage');
    }
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
  void initState() {
   // _authenticate();
    //_initAdMob();
    super.initState();

    startTime();
    initOnsignal();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/splashlogo.png',
        ),
      ),
    );
  }
}
