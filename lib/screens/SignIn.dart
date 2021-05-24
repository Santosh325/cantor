import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mycantor/home/Home.dart';
import 'package:mycantor/message/SignInDetails.dart';
import 'package:mycantor/progressWidget/progressDialog.dart';
import 'package:mycantor/screens/AddDetails.dart';
import 'package:mycantor/screens/SignUp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:mycantor/validator/validator.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var status = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xff9450e7),
        automaticallyImplyLeading: false,
        title: Text("Sign in", style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                    height: 200,
                    width: 200,
                    child: SvgPicture.asset('images/online.svg')),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 700,
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.zillaSlab(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: formkey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Email Address:',
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
                                  validator: validateEmail,
                                  controller: email,
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
                                      hintText: "Email Address",
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
                                  controller: password,
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
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          )),
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 5),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          print("forget password");
                                        },
                                        child: Text(
                                          'Forget Password?',
                                          style: GoogleFonts.sansita(),
                                        ))),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 25, right: 25),
                                width: 420,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff9450e7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    if (formkey.currentState.validate()) {
                                      _checkConnectivity();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please enter a valid Email address and password.");
                                    }
                                    Provider.of<SignInDetails>(context,
                                            listen: false)
                                        .signIn(email.text);
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.firaSans(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "I'am new user",
                                      style: GoogleFonts.sansita(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (contet) => SignUp()),
                                          );
                                        },
                                        child: Text(
                                          'Sign Up',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginToFirebase() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "  Authenticating please wait..");
        });

    try {
      final UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      email.clear();
      password.clear();

      print("SignIN PAGEEEEEEEEEEE......");
      if (user != null) {
        print('Success login');
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }

      //   .whenComplete(() => {
      //         setState(() {
      //           showCirclur = false;
      //         }),
      //       })
      //   .then((_) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Login SuccessFully')));

      // }).catchError((e) {
      //   if (e.code == 'user-not-found') {
      //     print('No user found for that email.');
      //     Fluttertoast.showToast(msg: "No user found for that email.");
      //   } else if (e.code == 'wrong-password') {
      //     print('Wrong password provided for that user.');
      //     Fluttertoast.showToast(msg: "You've entered wrong password");
      //   }
      // });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Invalid password");
        print('Wrong password provided for that user.');
      }
      Navigator.pop(context);

      print(e);
    }
  }

  void _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      loginToFirebase();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      loginToFirebase();
    } else {
      Fluttertoast.showToast(msg: "Please Check Internet connection");
    }
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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
}
