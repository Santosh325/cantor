import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycantor/message/SignInDetails.dart';
import 'package:mycantor/screens/AddDetails.dart';
import 'package:mycantor/screens/FirstPage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mycantor/screens/finalPage.dart';
import 'package:mycantor/screens/updateDetails.dart';
import 'package:provider/provider.dart';
import 'package:mycantor/services/database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:share/share.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mycantor/home/Home.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var indexNo;
  var key;
  DocumentSnapshot details;
  var documentId;
  var data;
  CollectionReference users = FirebaseFirestore.instance.collection('details');
  // Future<void> deleteUser(DocumentSnapshot documentSnapshot) async {
  //   await users.doc(documentSnapshot.id).delete();
  // }
  String text = 'https://medium.com/@suryadevsingh24032000';
  String subject = 'follow me';
  var userProvider;
  // here document index got deleted.
  void deleteuser(int index) async {
    QuerySnapshot querySnapshot = await users.get();
    querySnapshot.docs[index].reference.delete();
  }

  void shareData(int index) async {
    QuerySnapshot querySnapshot = await users.get();
    var data = querySnapshot.docs[index].data();

    var images = data['images'];
    var titleData = data['title'];
    var descriptionData = data['description'];
    print("this is shareData function!!!!");
    print(images);
    print(titleData);
    print(descriptionData);
    await Share.share(
      titleData,
      subject: descriptionData,
    );
  }

  void showDetails(int index) async {
    QuerySnapshot querySnapshot = await users.get();
    var data = querySnapshot.docs[index].data();
    var textEditTitle = data['title'];
    var textEditDescription = data['description'];
    print("this is showDetails function!!!");
    print(textEditTitle);
    print(textEditDescription);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => UpdateDetails(
        index: index,
        detailsTitle: textEditTitle,
        detailsDescription: textEditDescription,
      ),
    );
  }

  // DocumentSnapshot _documentSnapshot;
  // DocumentSnapshot details;
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit"),
              content: Text("Do you really want to exit this app."),
              actions: [
                FlatButton(
                  child: Text("CANCEL",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF6200EE),
                      )),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                    child: Text(
                      "YES",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF6200EE),
                      ),
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    }),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // Empty Function.

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // title: Align(alignment: Alignment.topRight, child: Text('Logout')),
          title: Text('Home page'),
          backgroundColor: Colors.deepPurpleAccent,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDetails()),
                  );
                }),
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // firebaseAuth.signOut();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => FirstPage()),
                // );
                // Route route =
                //     MaterialPageRoute(builder: (context) => FirstPage());
                // Navigator.pushReplacement(context, route);
                // firebaseAuth.signOut();

                showAlertDialog(context);
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("details").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              // if (snapshot.hasError) {
              //   return Center(child: Text('Something went wrong'));
              // }

              // if (snapshot.connectionState == ConnectionState.done) {
              //   return Center(child: Text("Loading..."));
              // }
              print(snapshot.data);
              print("im snapshot");

              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  details = snapshot.data.docs[index];
                  print(index);
                  print(details.data().values);

                  print("im in home page!!!!!");
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    key: ObjectKey(snapshot.data.docs.elementAt(index)),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              offset: Offset(-6.0, -6.0),
                              blurRadius: 16.0,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(6.0, 6.0),
                              blurRadius: 16.0,
                            ),
                          ],
                          color: Color(0xFFEFEEEE),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FinalPage()));
                          },
                          contentPadding: EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              details['image'],
                            ),
                          ),
                          title: Text(
                            details['title'] ?? 'default title ',
                            style: TextStyle(fontSize: 24),
                          ),
                          subtitle: Text(
                            details['description'] ?? 'Default description ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Archive',
                        color: Colors.blue,
                        icon: Icons.archive,
                        onTap: () => {},
                      ),
                      IconSlideAction(
                        caption: 'Share',
                        color: Colors.indigo,
                        icon: Icons.share,
                        onTap: () {
                          shareData(index);
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'More',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () => {},
                      ),
                      IconSlideAction(
                        caption: 'Update',
                        color: Colors.deepPurpleAccent,
                        icon: Icons.update,
                        onTap: () => {
                          // showModalBottomSheet(
                          //   isScrollControlled: true,
                          //   context: context,
                          //   builder: (context) => UpdateDetails(
                          //     index: index,
                          //     detailsTitle: details['title'],
                          //     detailsDescription: details['description'],
                          //   ),
                          // ),
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => UpdateDetails(
                          //             index: index,
                          //             detailsTitle: details['title'],
                          //             detailsDescription:
                          //                 details['description'],
                          //           ),
                          //       settings: RouteSettings(arguments: index)),
                          // ),
                          showDetails(index),
                          print("update button clicked"),
                        },
                      ),
                      IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,

                          // onTap: () => {
                          //   setState(() {
                          //     snapshot.data.docs.removeAt(index);
                          //   }),
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(content: Text("item deleted")))
                          // },
                          onTap: () => {
                                deleteuser(index),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("item ${index + 1} deleted"),
                                  ),
                                ),
                              }),
                    ],
                  );
                },
              );
            }),

        //here is my desiging stuff
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Yes",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF6200EE),
          )),
      onPressed: () async {
        try {
          Navigator.of(context).pop();
          Route route = MaterialPageRoute(builder: (context) => FirstPage());
          Navigator.pushReplacement(context, route);
          return await FirebaseAuth.instance.signOut();
        } catch (e) {
          print(e.toString());
          return null;
        }
      },
    );
    Widget continueButton = FlatButton(
      child: Text("No",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF6200EE),
          )),
      onPressed: () => Navigator.pop(context, false),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My Cantor"),
      content: Text("Do you want to Log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> share(dynamic link, String title) async {
    await FlutterShare.share(
        title: 'This is title',
        text: title,
        linkUrl: link,
        chooserTitle: 'please shared');
  }
}
