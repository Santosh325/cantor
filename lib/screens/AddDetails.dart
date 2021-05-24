import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycantor/home/Home.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mycantor/message/SignInDetails.dart';
import 'package:mycantor/progressWidget/progressDialog.dart';
import 'package:mycantor/screens/FirstPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:mycantor/services/database.dart';
import 'package:path/path.dart' as path;

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails>
    with SingleTickerProviderStateMixin {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  File _image;
  String imgUrl;
  ImagePicker picker = ImagePicker();
  PickedFile _pickedFile;
  AnimationController _controller;
  Animation<Color> animation;
  _AddDetailsState() {
    _controller = AnimationController(
        duration: Duration(milliseconds: 10000), vsync: this);
    animation = ColorTween(
      begin: Color.fromRGBO(230, 120, 80, 1.0),
      end: Color.fromRGBO(0, 180, 255, 1.0),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }
  Future<void> getImageFromCamera() async {
    _pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 25);
    setState(() {
      if (_pickedFile != null) {
        // _image.add(File(_pickedFile.path));
        _image = File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    _pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
    setState(() {
      if (_pickedFile != null) {
        // _image.add(File(_pickedFile.path));
        _image = File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //   Future<void> uploadFile() async {
  //   var storageImage = storage.ref().child(_image.path);

  //   var task = await storageImage.putFile(_image);
  //   imgUrl = await task.ref.getDownloadURL();
  //   await firestore
  //       .collection("imagesDetail")
  //       .add({'title': title, 'description': description, 'image': imgUrl});
  // }
  Future<void> uploadFile(String title, String description) async {
    // .child('sightings/${Path.basename(_image.path)}');
    var storageImage =
        storage.ref().child('details/${path.basename(_image.path)}');

    var task = await storageImage.putFile(_image);
    imgUrl = await task.ref.getDownloadURL();
    await firestore
        .collection("details")
        .add({'title': title, 'description': description, 'image': imgUrl});
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        title: Align(alignment: Alignment.topRight, child: Text('Upload')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.upload_file,
              color: Colors.white,
            ),
            onPressed: () {
              uploadFile(title.text, description.text);

              if (_image != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              } else {
                Fluttertoast.showToast(msg: "Please select image first");
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text(
                    'Add Form',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _image != null ? FileImage(_image) : null,
                            backgroundColor: Colors.black38,
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      _image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.deepPurpleAccent, spreadRadius: 1),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextField(
                    autofocus: true,
                    controller: title,
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: 'Enter title',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.deepPurpleAccent, spreadRadius: 1),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: TextField(
                    controller: description,
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: 'Enter description',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showLoaderDialog(BuildContext context) {
  AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(" Loading...")),
      ],
    ),
  );
}
