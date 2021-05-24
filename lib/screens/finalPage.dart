import 'package:flutter/material.dart';
import 'package:mycantor/message/SignInDetails.dart';
import 'package:provider/provider.dart';

class FinalPage extends StatefulWidget {
  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final page'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 400,
                width: double.infinity,
                color: Colors.amberAccent,
                child: Center(
                  child: Consumer<SignInDetails>(
                    builder: (context, userName, child) {
                      String message = "Welcome, ${userName.user}";
                      return Text(message,
                          style: Theme.of(context).textTheme.headline4);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
