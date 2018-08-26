import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
    _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _auth = FirebaseAuth.instance;

  final _passwordFocusNode = new FocusNode();

  _signInWithEmail() async {
    final result = _verifyInput();
    if (result == true) {
      try {
        await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        print("DONE");
      } catch(error) {
        showDialog(context: context, builder: (BuildContext context) => _buildAlert(error.toString(), context));
      }
    } else {
      showDialog(context: context, builder: (BuildContext context) => _buildAlert("Invalid Email or Password", context));
    }
  }

  bool _verifyInput() {
    if (_emailController.text.isNotEmpty && _emailController.text.contains("@")) {
      if (_passwordController.text.isNotEmpty && _passwordController.text.length >= 8) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Widget _buildAlert(String message, BuildContext context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(child: Text("Dismiss"), onPressed:() { Navigator.of(context).pop(); })
      ],
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  isDense: true,
                  suffixIcon: Icon(Icons.alternate_email)
                ),
              ),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                focusNode: _passwordFocusNode,
                onFieldSubmitted: (_) {
                  _signInWithEmail();
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  isDense: true,
                  suffixIcon: Icon(Icons.lock_outline),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                width: double.infinity,
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: () {
                    _signInWithEmail();
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                )
              )
            ]
          )
        )
      );
    }
}