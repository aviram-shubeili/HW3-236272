import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/providers/auth_notifier.dart';

class SavedNotifier with ChangeNotifier {
  static const String _savedCollectionName = 'savedPairs';
  static const String _savedArrayName = 'saved';
  Set<String> _saved = <String>{};
  AuthNotifier? _authNotifier;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => _authNotifier?.user?.uid;

  SavedNotifier();

  Set<String> get saved => _saved;

  set saved(Set<String> saved) {
    _saved = saved;
    debugPrint("saved set to $saved");
    notifyListeners();
  }

  void addSaved(String pair) {
    _saved.add(pair);
    syncWithStore();
    notifyListeners();
  }

  void removeSaved(String pair) {
    _saved.remove(pair);
    removeFromStore(pair);
    debugPrint('removed');
    notifyListeners();
  }

  void update(AuthNotifier authNotifier) {
    _authNotifier = authNotifier;
    syncWithStore();
  }

  Future<void> syncWithStore() async {
    if (uid != null) {
      final cloudSaved = await getCloudSaved();
      await _firestore
          .collection(_savedCollectionName)
          .doc(uid)
          .update({_savedArrayName: FieldValue.arrayUnion(_saved.toList())});
      saved = {..._saved, ...cloudSaved};
      saved.toSet().toList();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDoc() async {
    if (uid == null) {
      return null;
    }
    var doc = await _firestore.collection(_savedCollectionName).doc(uid).get();
    return doc.exists ? doc : null;
  }

  void createNewUserDoc() {
    _firestore
        .collection(_savedCollectionName)
        .doc(uid)
        .set({_savedArrayName: [],
              // 'isProfileSelected': false
        });
  }

  void removeFromStore(String pair) async {
    if (uid != null) {
      await _firestore
          .collection(_savedCollectionName)
          .doc(uid)
          .update({_savedArrayName: FieldValue.arrayRemove([pair])});
    }
  }

  Future<List<dynamic>> getCloudSaved() async {
    if (uid != null) {
      var doc = await getUserDoc();
      if (doc == null) {
        createNewUserDoc();
        return [];
      }
      return doc!.data()?[_savedArrayName];
    }
    return [];
  }
}
