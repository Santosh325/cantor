import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycantor/home/Home.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String uid;
  DatabaseService({this.uid});
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String fullName, String phone, String email) async {
    // Call the user's CollectionReference to add a new user
    return await users
        .doc(uid)
        .set({
          'name': fullName,
          'email': email,
          'phone': phone,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Future<void> updateUser(String title, String description, String id) async {
  //   return await users
  //       .doc(uid)
  //       .update({'title': title, 'description': description})
  //       .then((value) => print("Details updated"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }
}

// class DatabaseService {
//   final String uid;
  
//   Future<void> addUser(String fullName, String email, String phone) {
//     // Create a CollectionReference called users that references the firestore collection
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     // Call the user's CollectionReference to add a new user
//     return users
//         .add({
//           'name': fullName,
//           'email': email,
//           'phone': phone,
//         })
//         .then((value) => print("User Added"))
//         .catchError((error) => print("Failed to add user: $error"));
//   }
// }
