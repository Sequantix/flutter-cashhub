
import 'dart:ffi';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cashhub/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cashhub/services/ReaderService.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:merge_images/merge_images.dart';
import 'package:azblob/azblob.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  File _selectedFile;
  File _gotImage;
  bool _inProcess = false;
  Map data = {};
  Readerservice _readerservice;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();


  Widget getImageWidget() {

   // print(_gotImage.path);
    if(data['imageList']==null && _selectedFile !=null){
      _gotImage=_selectedFile;
     // print(_gotImage.path);
      return Image.file(
        _gotImage,
        width: 350,
        height: 650,
        fit: BoxFit.cover,
      );
    }
    else if (data['imageList'] != null) {
      _gotImage=data['imageList'];
      // ImagesMerge(
      //   data['imageList'],///required,images list
      //   direction: Axis.vertical,///direction
      //   backgroundColor: Colors.black26,///background color
      //   fit: false,///scale image to fit others
      //   //controller: captureController,///controller to get screen shot
      // );

      return Image.file(
        _gotImage,
        width: 350,
        height: 650,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/splashlogo.png",
        width: 350,
        height: 650,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    this.setState((){
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      // File cropped = await ImageCropper.cropImage(
      //     sourcePath: image.path,
      //     maxWidth: 1080,
      //     maxHeight: 1080,
      //
      //     compressFormat: ImageCompressFormat.jpg,
      //     androidUiSettings: AndroidUiSettings(
      //         toolbarColor: Colors.black,
      //         toolbarWidgetColor: Colors.white,
      //         //toolbarTitle: "RPS Cropper",
      //         statusBarColor: Colors.deepOrange.shade900,
      //         backgroundColor: Colors.black,
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: false
      //     ),
      //     iosUiSettings: IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //     )
      // );

      this.setState((){
        _selectedFile = image;
        _inProcess = false;
      });
    } else {
      this.setState((){
        _inProcess = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
//
// print("test");
    Future.delayed(Duration.zero, () {

      data = ModalRoute.of(context).settings.arguments;
      //print(data);
      if(data['pickerCode']=="1"){
        getImage(ImageSource.gallery);
      }
      else{
        getImage(ImageSource.camera);
      }
    });
  }


  Future<Readerservice> getImagedata() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    final bytes = _gotImage.readAsBytesSync();
    String img64 = base64Encode(bytes);


    final http.Response response = await http.post(
      'https://cashhub-test-ocrpy-last.azurewebsites.net/apiupload',
      // 'https://cashhub-dev-py-ocr.azurewebsites.net/apiupload',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      //body: map,
      body: jsonEncode(<String, String>{
        'img': img64,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final String responseString = response.body;
      return readerserviceFromJson(responseString);

   } else {
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Failed to load receipt data or Invalid Receipt",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);

     return null;
    }
  }
  checkimgStatus(){

    if(_readerservice.status == true){



      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Navigator.pushReplacementNamed(context, '/details',arguments: {
        'CompanyName':(_readerservice.merchantName).toString(),
        'TDate':(_readerservice.transactionDate).toString(),
        'Tax':(_readerservice.totalTax).toString(),
        'Total':(_readerservice.total).toString(),
        'items':(_readerservice.items).toList(),
        'imagess':_gotImage,
        'imagename':_gotImage.path.toString(),
        'saveaction':'1',
      });


    }else{
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Failed to load receipt data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      //print("failed");
    }

  }

  // blobdemo() async{
  //   var storage = AzureStorage.parse('your connection string');
  //   await storage.putBlob('/yourcontainer/yourfile.txt', body: 'Hello, world.');
  // }
  // }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30,),
                  getImageWidget(),
                  // ImagesMerge(
                  //   data['imageList'],///required,images list
                  //   direction: Axis.vertical,///direction
                  //   backgroundColor: Colors.black26,///background color
                  //   fit: false,///scale image to fit others
                  //   //controller: captureController,///controller to get screen shot
                  // ),
                  SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text("Recapture",
                          style: TextStyle(fontSize: 15),),
                        onPressed: () {
                           Navigator.of(context).pushReplacementNamed('/Mainpage');
                          //blobdemo();
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.orange,
                        child: Text("Snap",
                          style: TextStyle(fontSize: 15),),
                        onPressed: ()async{
                          final Readerservice reader = await getImagedata();
                          setState(() {
                            setState(() {
                              _readerservice = reader;
                            });
                          });
                          checkimgStatus();
                          //Navigator.pushNamed(context, '/details');
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              (_inProcess)?Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ):Center()
            ],
          ),
        )
    );
  }
}
