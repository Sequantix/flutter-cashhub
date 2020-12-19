import 'dart:async';
import 'package:cashhub/services/loginapi.dart';
import 'package:cashhub/services/signinapi.dart';
import 'package:cashhub/services/socialsigninservice.dart';
import 'package:flutter/material.dart';
import 'package:cashhub/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LogInSignIn extends StatefulWidget {
  @override
  _LogInSignInState createState() => _LogInSignInState();
}

class _LogInSignInState extends State<LogInSignIn>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController uname = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController sFullname = new TextEditingController();
  TextEditingController sEmail = new TextEditingController();
  TextEditingController sPassword = new TextEditingController();
  TextEditingController sPasswordrepeat = new TextEditingController();

  void cleartext() {
    uname.clear();
    password.clear();
    sFullname.clear();
    sEmail.clear();
    sPassword.clear();
    sPasswordrepeat.clear();
  }



  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Login _login;
  Signin _signin;
  Socialsignin _socialsignin;

  Future<Login> getProfileDetails(String uname, String pass) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    final http.Response response = await http.post(
      'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Email': uname,
        'Password': pass,
      }),
    );

    //print(response.body);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      //print(responseString);
      return loginFromJson(responseString);
    } else {
      return null;
    }
  }

  shared_Id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', (_login.id).toString());
    //print('hello');
    sharId();
  }

  sharId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intuserId', _login.id);
    //print('hello');
    shardname();
  }

  shardname()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserName', (_login.name).toString());
    shardemil();
  }
  shardemil() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserEmails', (_login.uemail).toString());
  }

  checkloginstatus() {
    if (_login.isSuccess == "true") {
      //print("success to go");
      cleartext();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      Navigator.of(context).pushReplacementNamed('/Mainpage', arguments: {
        'userId': (_login.id).toString(),
      });
      // Navigator.of(context).pushReplacementNamed('/Mainpage');

    } else {
      //print("failed to go");
      //Navigator.of(context).pushReplacementNamed('/Mainpage');
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      Fluttertoast.showToast(
          msg: "Username or Password incorrect..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

//signin

  Future<Signin> signUp(String sFullname, String sEmail, String sPassword,
      String sPasswordrepeat) async {
    if (sFullname == "" && sEmail == "" && sPassword == "" &&
        sPasswordrepeat == "") {
      Fluttertoast.showToast(
          msg: "Please fill all the fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } else{
      if (sPassword == sPasswordrepeat) {
      Dialogs.showLoadingDialog(context, _keyLoader);
      final http.Response response = await http.post(
        'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/AddCustomer',
        //'https://localhost:44396/api/CashHub/AddCustomer',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'FullName': sFullname,
          'Email': sEmail,
          'Password': sPassword,
        }),
      );

      //print(response.body);
      if (response.statusCode == 200) {
        final String responseString = response.body;
        return signinFromJson(responseString);
      } else {
        print((response.statusCode));
      }
    } else {
      //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      Fluttertoast.showToast(
          msg: "password does not Match..!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
  }

  checksignupstatus() {
    if (_signin.status == "true") {
      cleartext();
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      Fluttertoast.showToast(
          msg: "Successfully Registered..!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
    } else {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      Fluttertoast.showToast(
          msg: "Registeratation Failed..!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

//googleauth
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    print("signed in " + user.displayName);
    print("mailid " + user.email);
    //if(user.email != null){
    Dialogs.showLoadingDialog(context, _keyLoader);
    final Socialsignin sosign = await Sociallog(user.displayName, user.email);

    setState(() {
      _socialsignin = sosign;
    });
      setState(() {
        _socialsignin == null ?
        Container()
            : soshared_Id();
      });

    return user;
  }

  //twitter
  Future<FirebaseUser> _twsignin() async {
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'EVSVqq1Ib4c0Qh5gbetBgMsuU',
      consumerSecret: 'mpfgw5I9lS2wyvcMIe9PuAzaUiI9umfSncU2mFGDdtLcJgXjeR',
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    // Create a credential from the access token
    final AuthCredential twitterAuthCredential =
        TwitterAuthProvider.getCredential(
            authToken: twitterSession.token,
            authTokenSecret: twitterSession.secret);

    // Once signed in, return the UserCredential
    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
    FirebaseUser user = authResult.user;

    print(user.displayName);
    print(user.email);
    Dialogs.showLoadingDialog(context, _keyLoader);
    final Socialsignin tsign = await Sociallog(user.displayName, user.email);

    setState(() {
      _socialsignin = tsign;
    });
    setState(() {
      _socialsignin == null ?
      Container()
          : soshared_Id();
    });
    return user;
  }
//fblogin
  Future<FirebaseUser> _fbsignin() async {

    //Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final AuthCredential facebookAuthCredential =
    FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

    // Once signed in, return the UserCredential
    final AuthResult authResult =await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    FirebaseUser user = authResult.user;

    print(user.displayName);
    print(user.email);

    Dialogs.showLoadingDialog(context, _keyLoader);
    final Socialsignin fsign = await Sociallog(user.displayName, user.email);

    setState(() {
      _socialsignin = fsign;
    });
    setState(() {
      _socialsignin == null ?
      Container()
          : soshared_Id();
    });
    return user;

  }

//social signup google
  Future<Socialsignin> Sociallog(String FuName, String FuEmail) async {
    final http.Response response = await http.post(
      'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/sociallog',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'FullName': FuName,
        'Email': FuEmail,
      }),
    );

    print(response.body);
   // if (response.statusCode == 200) {
      final String responseString = response.body;
      return socialsigninFromJson(responseString);
    // } else {
    //   print((response.statusCode));
    // }
    // _signin == null ?
    // Container()
    //     : soshared_Id();

  }

  soshared_Id() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', (_socialsignin.id).toString());
    prefs.setString('UserName', (_socialsignin.fullname).toString());
    prefs.setString('UserEmails', (_socialsignin.uemail).toString());
    sosharId();
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
        .pop();
    Navigator.of(context).pushReplacementNamed('/Mainpage');
  }

  sosharId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intuserId', _socialsignin.id);
  }
emailfailed(){
  Fluttertoast.showToast(
      msg: "Invalid Email-id",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}
fillall(){
  Fluttertoast.showToast(
      msg: "Please fill all fields",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      //child: SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                child: Image.asset('assets/Loginogo.png', height: 100),
              ),
              SizedBox(height: 40),
              Container(
                height: 45,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Colors.green,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Login',
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Signin',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Container(
                            width: 340,
                            height: 50,
                            child: TextFormField(
                              controller: uname,
                              autovalidate: true,


                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.account_circle),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Email",
                                  hintText: "e.g. abc@xyz.com",
                                  fillColor: Colors.grey[300]),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 340,
                            height: 50,
                            child: TextFormField(
                              controller: password,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: InkWell(
                                    onTap: _toggle,
                                    child: Icon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Password",
                                  fillColor: Colors.grey[300]),

                              obscureText: _obscureText,
                            ),
                          ),
                          FlatButton(
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Forgot Password ?',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/resetpassword');
                            },
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ButtonTheme(
                                minWidth: 140.0,
                                height: 45.0,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                                    // onPressed: ()async {
                                    //
                                    final Login login = await getProfileDetails(
                                        uname.text.toString(),
                                        password.text.toString());

                                    setState(() {
                                      setState(() {
                                        _login = login;
                                      });
                                    });
                                    checkloginstatus();
                                    shared_Id();
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                )),
                          ),
                          SizedBox(height: 70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _fbsignin();
                                },
                                child: Container(
                                    //alignment: Alignment.center,
                                    height: 40.0,
                                    child: Image(
                                      image: AssetImage('assets/fb.png'),
                                    )),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                child: Container(
                                    //alignment: Alignment.center,
                                    height: 40.0,
                                    child: Image(
                                      image: AssetImage('assets/google.png'),
                                    )),
                                onTap: () async {
                                  _signIn();
                                },
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                child: Container(
                                    //alignment: Alignment.center,
                                    height: 40.0,
                                    child: Image(
                                      image: AssetImage('assets/twitter.png'),
                                    )),
                                onTap: () {
                                  _twsignin();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // second tab bar view widget
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Container(
                            width: 340,
                            height: 50,
                            child: TextFormField(
                              controller: sFullname,

                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.account_circle),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Full Name",
                                  hintText: "e.g. John Wick",
                                  fillColor: Colors.grey[300]),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 340,
                            height: 50,
                            child: TextFormField(
                              controller: sEmail,
                              autovalidate: true,

                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.email),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Email",
                                  hintText: "e.g abc@gmail.com",
                                  fillColor: Colors.grey[300]),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 340,
                            height: 50,
                            child: TextFormField(
                              controller: sPassword,

                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: InkWell(
                                    onTap: _toggle,
                                    child: Icon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Password",
                                  fillColor: Colors.grey[300]),

                              obscureText: _obscureText,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 340,
                            child: TextFormField(
                              controller: sPasswordrepeat,

                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: InkWell(
                                    onTap: _toggle,
                                    child: Icon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelText: "Confirm-Password",
                                  fillColor: Colors.grey[300]),

                              obscureText: _obscureText,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Already have an account? ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: 'Login here !',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue[600])),
                                    ],
                                  ),
                                ),
                              ),
//                    Text(
//                      'Already have an account? Login here !',
//                      textAlign: TextAlign.right,
//                    ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/HomeScreen');
                            },
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ButtonTheme(
                                minWidth: 140.0,
                                height: 80.0,
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text(
                                    "SIGNIN",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    //Navigator.of(context).pushReplacementNamed('/HomeScreen');
                                    // onPressed: ()async {
                                    //
                                    final Signin signin = await signUp(
                                        sFullname.text.toString(),
                                        sEmail.text.toString(),
                                        sPassword.text.toString(),
                                        sPasswordrepeat.text.toString());

                                    setState(() {
                                      setState(() {
                                        _signin = signin;
                                      });
                                    });

                                    checksignupstatus();
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                )),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      // ),
    ));
  }
}
