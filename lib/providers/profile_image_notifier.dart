import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_notifier.dart';

class ProfileImageNotifier with ChangeNotifier {

  AuthNotifier? _authNotifier;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  static const Widget _defaultUserImage = Image( image: AssetImage('assets/default_user.png'), fit: BoxFit.cover);


  static const String _cloudPath = 'profileImages/';

  String _fileURL = '';

  String? get uid => _authNotifier?.user?.uid;
  Widget _userImage = _defaultUserImage;

  String get fileName => "profile_${_authNotifier!.user!.uid}";

  Widget get userImage => _userImage;


  Future<void> update(AuthNotifier authNotifier) async {
    _authNotifier = authNotifier;
    _fileURL = '';
    _userImage = _defaultUserImage;
    notifyListeners();
    if (uid != null) {
      await _getProfileFromCloud();
    }
    notifyListeners();
  }

  Future<void> _getProfileFromCloud() async {
    if (await _userChosenProfileImage()) {
      try {
        _fileURL = await _downloadProfile();
        _userImage = CircleAvatar(
            backgroundColor: Colors.red,
            radius: 65,
            backgroundImage: AssetImage('assets/loading.gif'),
            child: CircleAvatar(
                radius: 65,
                backgroundColor:Colors.transparent,
                backgroundImage:NetworkImage(_fileURL)));
      } catch (e) {
        _userImage = _defaultUserImage;
        notifyListeners();
        debugPrint('Caught $e');
      }
    }
  }

  Future<bool> _userChosenProfileImage() async {
    return true;
    // return (await _firestore.collection('savedPairs').doc(uid).get()).data()?['isProfileSelected'];
  }

  Future<String> _downloadProfile() async {
    return _storage
        .ref(_cloudPath)
        .child(fileName)
        .getDownloadURL();
  }

  void updateNewProfileImage(String localPath) {
    // update local
    _userImage = ClipOval(child: Image.file(File(localPath), fit: BoxFit.cover));
    notifyListeners();
    // continue to update on cloud.
    var fileRef = _storage.ref(_cloudPath).child(fileName); // cloudPath = images/profile.jpg
    var file = File(localPath);
    debugPrint('Updating in storage');
    fileRef.putFile(file).catchError((e) => debugPrint('Caught $e'));
  }

  Widget _loadingBuilder(BuildContext context, Widget child,
      ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}