import 'package:firebase_storage/firebase_storage.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageRepository {
  Future<String> getImage(String? imgName) async {
    if (imgName == null) {
      throw Exception("No image found");
    }
    try {
      var urlRef = firebaseStorage
          .child('cat_profile')
          .child('${imgName.toLowerCase()}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class ProfilePicRepository {
  final allPictureImages = <String>[];

  Future<List<String>> getAllPictures() async {
    List<String> imgName = [
      "happy",
      "fun",
      "angry",
      "smart",
      "sad",
      "shy",
      "surprise",
      "sigh",
      "love"
    ];
    try {
      for (var img in imgName) {
        final imgUrl = await FirebaseStorageRepository().getImage(img);
        allPictureImages.add(imgUrl);
      }
      return allPictureImages;
    } catch (e) {
      throw Exception(e);
    }
  }
}

