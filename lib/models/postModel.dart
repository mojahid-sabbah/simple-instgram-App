import 'package:cloud_firestore/cloud_firestore.dart';

class postModel {
  final String profileImg;
  final String username;
  final String description;
  final String imgPost;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List likes;

  postModel(
      {required this.profileImg,
      required this.username,
      required this.description,
      required this.imgPost,
      required this.uid,
      required this.postId,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> convert2Map() {
    return {
      'profileImg': profileImg,
      'username': username,
      'description': description,
      'imgPost': imgPost,
      "uid": uid,
      'postId': postId,
      'datePublished': datePublished,
      "likes": likes,
    };
  }

// for a provider
  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return postModel(
      profileImg: snapshot["profileImg"],
      username: snapshot["username"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
    );
  }
}
