import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userImg;
  String password;
  String? phone;
  String? userName;
  String email;
  String? uid;
  List followers;
  List following;
  String Bio;

  UserModel(
      {required this.email,
      required this.password,
      this.phone,
      this.userImg,
      this.userName,
      this.uid,
      required this.followers,
      required this.following,
      required this.Bio});

  Map<String, dynamic> convert2Map() {
    return {
      'email': email,
      'userName': userName,
      'phone': phone,
      'password': password,
      "userImg": userImg,
      "uid": uid,
      'followers': followers,
      'following': following,
      "Bio": Bio,
    };
  }

// for a provider
  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot["email"],
      userName: snapshot["userName"],
      phone: snapshot["phone"],
      password: snapshot["password"],
      userImg: snapshot["userImg"],
      uid: snapshot["uid"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      Bio: snapshot["Bio"],
    );
  }
}
