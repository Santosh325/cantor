import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

import 'package:flutter/material.dart';

class UpdateDetails extends StatefulWidget {
  final int index;
  final String detailsTitle, detailsDescription;

  const UpdateDetails(
      {Key key, this.index, this.detailsTitle, this.detailsDescription})
      : super(key: key);

  @override
  _UpdateDetailsState createState() =>
      _UpdateDetailsState(index, detailsTitle, detailsDescription);
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final int index;
  final String detailsTitle, detailsDescription;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var keyIndex;
  DocumentSnapshot details;
  var documentId;
  CollectionReference users = FirebaseFirestore.instance.collection('details');
  FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  _UpdateDetailsState(this.index, this.detailsTitle, this.detailsDescription) {
    this.title = TextEditingController()..text = detailsTitle;
    this.description = TextEditingController()..text = detailsDescription;
  }

  void updateUser(int index, String title, String description) async {
    QuerySnapshot querySnapshot = await users.get();
    querySnapshot.docs[index].reference
        .update({'title': title, 'description': description});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // color: Color(0xff757575),

        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                    color: Colors.deepPurpleAccent,
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
                  child: TextFormField(
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
                  height: 100,
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
                  child: TextFormField(
                    controller: this.description,
                    decoration: new InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: 'Enter description',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 80,
                    right: 80,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () async {
                      updateUser(index, title.text, description.text);

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Update',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff9450e7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
