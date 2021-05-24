import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycantor/progressWidget/progressDialog.dart';
import 'package:mycantor/screens/AddDetails.dart';
import 'package:mycantor/screens/SignIn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycantor/services/database.dart';
import 'package:mycantor/validator/validator.dart';
import 'package:mycantor/message/SignInDetails.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class SignUp extends StatefulWidget {
  static const String id = "signUp";
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xff9450e7),
          automaticallyImplyLeading: false,
          title: Text("Sign Up", style: GoogleFonts.poppins()),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                    width: 200,
                    height: 150,
                    child: SvgPicture.asset('images/online.svg')),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 720,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.zillaSlab(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Full Name:',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    )),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  autofocus: true,
                                  validator: validateName,
                                  controller: fullNameController,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(20.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Full Name",
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Phone Number:',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  validator: validateMobile,
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(20.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Phone Number",
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Email Address:',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  validator: validateEmail,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(20.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "email Address",
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Password:',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  validator: validatePassword,
                                  controller: passWordController,
                                  obscureText: _obscureText,
                                  decoration: new InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(20.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Password",
                                      suffixIcon: InkWell(
                                          onTap: _toggle,
                                          child: Icon(_obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility)),
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 25, right: 25, bottom: 20),
                                width: 420,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff9450e7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  onPressed: () async {
                                    if (formkey.currentState.validate()) {
                                      _checkConnectivity();
                                    } else {
                                      print("Not Validated");
                                    }
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: GoogleFonts.firaSans(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "I'am already a User",
                                      style: GoogleFonts.sansita(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => SignIn()),
                                          );
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: GoogleFonts.firaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xff9450e7),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerToFirebase() async {
    try {
      UserCredential newUser =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: emailController.text, password: passWordController.text);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(message: "Authenticating please wait..");
          });
      User user = newUser.user;
      print(user);

      await DatabaseService(uid: user.uid).addUser(fullNameController.text,
          phoneNumberController.text, emailController.text);

      // await DatabaseService().addUser(fullNameController.text,
      //     phoneNumberController.text, emailController.text);

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
        emailController.clear();
        passWordController.clear();
        phoneNumberController.clear();
        fullNameController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          Fluttertoast.showToast(msg: "Email has been already registered.");
        }
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    print('$emailController.text$passWordController.text');
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: animationController
                .drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),
          ),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text(" Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      registerToFirebase();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      registerToFirebase();
    } else {
      Fluttertoast.showToast(msg: "Please Check Internet connection");
    }
  }
}
