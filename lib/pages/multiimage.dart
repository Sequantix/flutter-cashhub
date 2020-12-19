import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as immg;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cashhub/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cashhub/services/ReaderService.dart';
import 'package:cashhub/pages/loader.dart';
import 'package:merge_images/merge_images.dart';
import 'package:path/path.dart' as pt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';


class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  List<Object> images = List<Object>();
  List<File> imgList = List<File>();
  List<Image> listimg = [];
  List<Image> d = [];
  //Future<File> _imageFile;
  File _selectedFile;
  File _finalfile;
  Image _finalimage;
  bool _inProcess = false;
  Map data = {};
  Readerservice _readerservice;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.only(left: 12),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,),
              onPressed: () {
                Navigator.pushNamed(context, '/Mainpage');

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
        Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(children: <Widget>[
              Text('Receipt',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Picker',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
            SizedBox(height: 40),
            Text('In case of long receipts divide it and merge it here'),
            SizedBox(height: 10),
            Expanded(
              child: buildGridView(),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.orange,
                    child: Text("Finish",
                      style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      pasimage();
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                  ),

                ],
              ),
            ),

          ],

        ),
      ),

    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
          if (images[index] is ImageUploadModel) {
            ImageUploadModel uploadModel = images[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    uploadModel.imageFile,
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          images.replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //popup
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 16,
                        child: Container(
                          height: 180.0,
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
                                  _onAddImageClick(index, ImageSource.camera);
                                  Navigator.of(context).pop();

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
                                  _onAddImageClick(index, ImageSource.gallery);
                                  Navigator.of(context).pop();
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
                  //_onAddImageClick(index);
                },
              ),
            );
          }

      }),
    );

  }

  Future  _onAddImageClick(int index, ImageSource source ) async {
    setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          maxWidth: 1080,
          maxHeight: 1080,

          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              //toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false
          ),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

      this.setState((){
        _selectedFile = cropped  ;
        _inProcess = false;
      });
    } else {
      this.setState((){
        _inProcess = false;
      });
    }

    _selectedFile==null?
        Container():getFileImage(index);
  }


  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = _selectedFile ;
      imageUpload.imageUrl = '';
      imgList.add(imageUpload.imageFile);
      images.replaceRange(index, index + 1, [imageUpload]);
      print(imgList);
    });
  }
  Future  pasimage() async{
    ui.Image images;
    ui.Image imagez;
    ui.Image imagez1;
    ui.Image imagez2;
    ui.Image imagez3;

    if(imgList.length==0){
      Fluttertoast.showToast(
          msg: "Please select atleast one receipt",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }else if(imgList.length==1){
      imagez = await ImagesMergeHelper.loadImageFromFile(imgList[0]);
      images = await ImagesMergeHelper.margeImages(
          [imagez],

          ///required,images list
          fit: true,

          ///scale image to fit others
          direction: Axis.vertical,

          ///direction of images
          backgroundColor: Colors.black26);
    }else if(imgList.length==2){
      imagez = await ImagesMergeHelper.loadImageFromFile(imgList[0]);
      imagez1 = await ImagesMergeHelper.loadImageFromFile(imgList[1]);
      images = await ImagesMergeHelper.margeImages(
          [imagez,imagez1],

          ///required,images list
          fit: true,

          ///scale image to fit others
          direction: Axis.vertical,

          ///direction of images
          backgroundColor: Colors.black26);
    }else if(imgList.length==3){
      imagez = await ImagesMergeHelper.loadImageFromFile(imgList[0]);
      imagez1 = await ImagesMergeHelper.loadImageFromFile(imgList[1]);
      imagez2 = await ImagesMergeHelper.loadImageFromFile(imgList[2]);
      images = await ImagesMergeHelper.margeImages(
          [imagez,imagez1,imagez2],

          ///required,images list
          fit: true,

          ///scale image to fit others
          direction: Axis.vertical,

          ///direction of images
          backgroundColor: Colors.black26);
    }else if(imgList.length==4){
      imagez = await ImagesMergeHelper.loadImageFromFile(imgList[0]);
      imagez1 = await ImagesMergeHelper.loadImageFromFile(imgList[1]);
      imagez2 = await ImagesMergeHelper.loadImageFromFile(imgList[2]);
      imagez3 = await ImagesMergeHelper.loadImageFromFile(imgList[3]);
      images = await ImagesMergeHelper.margeImages(
          [imagez,imagez1,imagez2,imagez3],

          ///required,images list
          fit: true,

          ///scale image to fit others
          direction: Axis.vertical,

          ///direction of images
          backgroundColor: Colors.black26);
    }



    _finalfile = await ImagesMergeHelper.imageToFile(images);
//   final image1 = immg.decodeImage(imgList[0].readAsBytesSync());
//   final image2 = immg.decodeImage(imgList[1].readAsBytesSync());
//   final mergedImage = immg.Image(image1.width + image2.width, max(image1.height, image2.height));
//  final documentDirectory = await getApplicationDocumentsDirectory();
//   final file = new File(pt.join(documentDirectory.path, "merged_image.jpg")).writeAsBytesSync(immg.encodeJpg(mergedImage));
//   //final _finalfile=file.writeAsBytesSync(immg.encodeJpg(mergedImage));
//   _finalfile=file;
//   //_finalimage
// print(file);






    // immg.copyInto(mergedImage, image1, blend = false);
    //  immg.copyInto(mergedImage, image2, dstx = image1.width, blend = false);
//
// for(var i=0;i<imgList.length;i++){
//   final imaes = immg.decodeImage(imgList[i].readAsBytesSync()) as Image;
//   //ImagesMergeHelper.loadImageFromProvider( NetworkImage(file: imaes));
//   // final imaes = immg.decodeImage(imgList[i].readAsBytesSync()) as Image;
//   listimg.add(imaes);
//  print(listimg);
// }
//


    Navigator.pushNamed(context, '/crop',arguments: {
      'imageList':_finalfile
      // ImagesMerge(
      //   d,///required,images list
      //   direction: Axis.vertical,///direction
      //   backgroundColor: Colors.black26,///background color
      //   fit: false,///scale image to fit others
      //   //controller: captureController,///controller to get screen shot
      // ),
    });
  }
  Widget getImageWidget() {
    if (_finalfile != null) {
      return Image.file(
        _finalfile,
        width: 350,
        height: 350,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/splashlogo.png",
        width: 350,
        height: 350,
        fit: BoxFit.cover,
      );
    }
  }


}



class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}