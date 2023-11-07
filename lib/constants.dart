// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loopsie/controller/auth_controller.dart';
// import 'package:tiktok_tutorial/controllers/auth_controller.dart';
// import 'package:tiktok_tutorial/views/screens/add_video_screen.dart';
// import 'package:tiktok_tutorial/views/screens/profile_screen.dart';
// import 'package:tiktok_tutorial/views/screens/search_screen.dart';
// import 'package:tiktok_tutorial/views/screens/video_screen.dart';

// const List pages = [
//   Text('Homescreen'),
//   Text('search screen'),
//   Text('Add video'),
//   Text('Messages screen'),
//   Text('profile screen'),

//   // VideoScreen(),
//   // SearchScreen(),
//   // const AddVideoScreen(),
//   // Text('Messages Screen'),
//   // ProfileScreen(uid: authController.user.uid),
// ];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// // CONTROLLER
var authController = AuthController.instance;
