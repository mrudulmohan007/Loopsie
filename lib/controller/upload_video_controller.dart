import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:loopsie/constants.dart';
import 'package:loopsie/model/video.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    try {
      Reference ref = firebaseStorage.ref().child('videos').child(id);
      UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading video: $e");
      return 'ERROR OCCURED';
    }
  }

  Future<String> _uploadImageTostorage(String id, String videoPath) async {
    try {
      Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
      UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading thumbnail: $e");
      return 'ERROR OCCURED';
    }
  }

  //upload video

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      //get video id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String? videoUrl = await _uploadVideoToStorage("video $len", videoPath);
      String? thumbnail = await _uploadImageTostorage("video $len", videoPath);
      //thumbnail of video
      if (videoUrl != null && thumbnail != null) {
        Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
          thumbnail: thumbnail,
        );
        await firestore
            .collection('videos')
            .doc('Video $len')
            .set(video.toJson());
        Get.back();
      } else {
        Get.snackbar('Error uploading', 'Failed to upload video or thumbnail');
      }
    } catch (e) {
      Get.snackbar(
        'Error uploading',
        e.toString(),
      );
    }
  }
}
