import 'dart:async';
import 'dart:convert';
import 'package:cashhub/services/payment-service.dart';
import 'package:cashhub/services/paymentservicesave.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
class perium_1 extends StatefulWidget {
  @override
  _perium_1State createState() => _perium_1State();
}

class _perium_1State extends State<perium_1> {
  PaymentSer _paymentSer;
  String paymentid;
  String paymentdate;
  int acid;


  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  payViaNewCard() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '2388',
        currency: 'USD'
    );
    await dialog.hide();
    print('1.1'+response.message);
    print(response.success);
    print(response.idss);
    if(response.success==true){
      paymentid=response.idss;
      // DateTime now = new DateTime.now();
      // paymentdate=now;
      // print(now);
      yearlysuccess();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('actidd');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('actidd', ("3"));
      Navigator.pushReplacementNamed(context, '/tsuccess');
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }else {
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
  successdata()async{
final PaymentSer paymentSer=await paymentSave(paymentid);
setState(() {
  setState(() {
    _paymentSer = paymentSer;
  });
});
  }
  yearlysuccess()async{
    final PaymentSer paymentSer=await ypaymentSave(paymentid);
    setState(() {
      setState(() {
        _paymentSer = paymentSer;
      });
    });
  }
  Future<PaymentSer> ypaymentSave(String payid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('userId');
    var one = int.parse(stringValue);
    print(one);
    print("from here!"+stringValue);
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    print(payid);
    final http.Response response = await http.post(
      'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/PaymentDetails',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "user_id":one,
        "payment_id":payid,
        "month":"yearly",
        "payement_date":formattedDate
      }),
    );

    print(response.body);
    // if (response.statusCode == 200) {
    final String responseString = response.body;
    return paymentSerFromJson(responseString);
    // } else {
    //   print((response.statusCode));
    // }
  }
 Future<PaymentSer> paymentSave(String payid) async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   //Return String
   String stringValue = prefs.getString('userId');
   var one = int.parse(stringValue);
   print(one);
   print("from here!"+stringValue);
   DateTime now = new DateTime.now();
   var formatter = new DateFormat('yyyy-MM-dd');
   String formattedDate = formatter.format(now);
   print(formattedDate);
   print(payid);
   final http.Response response = await http.post(
     'https://cashhub-reader-web-dev.azurewebsites.net/api/CashHub/PaymentDetails',
     headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },
     body: jsonEncode(<String, dynamic>{
       "user_id":one,
       "payment_id":payid,
       "month":"monthly",
       "payement_date":formattedDate
     }),
   );

   print(response.body);
   // if (response.statusCode == 200) {
   final String responseString = response.body;
   return paymentSerFromJson(responseString);
   // } else {
   //   print((response.statusCode));
   // }
 }
  payViaNewCardMonth() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '299',
        currency: 'USD'
    );
    await dialog.hide();
    print('1.1'+response.message);
    print(response.success);
    if(response.success==true){
      paymentid=response.idss;
      successdata();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('actidd');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('actidd', ("3"));
      Navigator.pushReplacementNamed(context, '/tsuccess');
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }else {
      Fluttertoast.showToast(
          msg: response.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }


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
          // icon: Icon(Icons.more_vert,
          // color: Colors.black,
          // size: 30,),
          // onPressed: () {
          // print('Click start');
          // },
          // ),
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(

                child: Image.asset('assets/premium.png')),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 6,),
                Container(
                  height: 130,
                  width: 180,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ButtonTheme(
                      minWidth: 140.0,
                      height: 45.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Column(
                          children: [
                            SizedBox(height: 17,),
                            Text(
                              "Annual Plan",
                              style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              "\$23.88 / year",
                              style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                            ),SizedBox(height: 10,),
                            Text(
                              "\$1.99 per month",
                              style: TextStyle(fontSize: 12,color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: ()  {
                          payViaNewCard();
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(30.0),
                        ),
                      )),
                ),
                SizedBox(width: 5,),
                Container(
                  height: 130,
                  width: 180,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ButtonTheme(
                      minWidth: 140.0,
                      height: 45.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Column(
                          children: [
                            SizedBox(height: 17,),
                            Text(
                              "Monthly Plan",
                              style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              "\$2.99 / month",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),SizedBox(height: 10,),

                          ],
                        ),
                        onPressed: ()  {
                          payViaNewCardMonth();
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius:
                          new BorderRadius.circular(30.0),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),

    );

  }
}