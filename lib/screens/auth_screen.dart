import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    File image,
    String email,
    String userName,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image') // the folder we wanna to save user image.
            .child(userCredential.user.uid +
                '.jpg'); // the image name we uploeded.
        // we now created our path , so let's upload the image. :)
        await ref.putFile(image).whenComplete(() => null);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'username': userName,
          'email': email,
          'image-url': url,
        });
      }
    } on FirebaseAuthException catch (error) {
      var message = 'An error occured. Please check your credentials.';

      if (error.code == 'weak-password') {
        message = error.code;
        print('--------------------------------------------------');
      } else if (error.code == 'email-already-in-use') {
        message = error.code;
      } else if (error.code == 'user-not-found') {
        message = error.code;
      } else if (error.code == 'wrong-password') {
        message = error.code;
      }
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
