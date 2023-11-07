import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopsie/constants.dart';
import 'package:loopsie/model/user.dart' as model;
import 'package:loopsie/views/screens/auth/login_screen.dart';
import 'package:loopsie/views/screens/homescreen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user; //firebase auth user

  late Rx<File?> _pickedImage;

  File? get ProfilePhoto => _pickedImage.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  //pickimage using camera
  void pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        Get.snackbar('Profile picture',
            'You have successfully selected your profile picture!');
      }

      if (pickedImage == null || pickedImage.path == null) {
        throw Exception('Image picking failed or no image selected');
      }

      _pickedImage = Rx<File?>(File(pickedImage.path));
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick an image: $e');
    }
  }

  //upload image to firestore storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('ProfilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //register the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //save user to our auth and firebase
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            email: email,
            name: username,
            uid: cred.user!.uid,
            profilePhoto: downloadUrl);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Error creating user',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error creating user',
        e.toString(),
      );
    }
  }

  //login user
  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('log success');
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
  }
}
