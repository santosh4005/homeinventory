import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_inventory/widgets/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor, 
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AuthForm(_submitAuthForm, isLoading),
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File userimagefile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authresult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        var imgRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authresult.user.uid + '.jpg');

        await imgRef.putFile(userimagefile).onComplete;
        final imageurl = await imgRef.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authresult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'imageurl': imageurl,
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occrred. Check your cred";

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).hideCurrentSnackBar();
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }
}
