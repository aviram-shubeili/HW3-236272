import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/providers/profile_image_notifier.dart';
import 'package:hello_me/screens/user_profile/profile_grabbing_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import '../../providers/auth_notifier.dart';

class ProfileSnappingPage extends StatefulWidget {
  Widget child;
  ProfileSnappingPage({required this.child, Key? key}) : super(key: key);

  @override
  State<ProfileSnappingPage> createState() => _ProfileSnappingPageState();
}

class _ProfileSnappingPageState extends State<ProfileSnappingPage> {
  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  static const List<SnappingPosition> snappingPositions = [
    SnappingPosition.factor(
      positionFactor: 0.0,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: Duration(seconds: 1),
      grabbingContentOffset: GrabbingContentOffset.top,
    ),
    SnappingPosition.factor(
      positionFactor: 0.23,
      snappingCurve: Curves.easeOutExpo,
      snappingDuration: Duration(seconds: 1),
      grabbingContentOffset: GrabbingContentOffset.bottom,
    ),
  ];
  final ImagePicker _imagePicker = ImagePicker();
  // Widget? _userImage;
  // User? _user;

  void toggleSheetPosition() {
    snappingSheetController.currentSnappingPosition == snappingPositions[0]
        ? snappingSheetController.snapToPosition(snappingPositions[1])
        : snappingSheetController.snapToPosition(snappingPositions[0]);
  }

  @override
  Widget build(BuildContext context) {
    var _user = context.watch<AuthNotifier>().user;
    var _userImage = context.watch<ProfileImageNotifier>().userImage;

    if (_user == null) {
      return widget.child;
    }
    return Scaffold(
        body: SnappingSheet(
            controller: snappingSheetController,
            snappingPositions: snappingPositions,
            grabbing: Material(
                child: InkWell(
                    onTap: toggleSheetPosition,
                    child: ProfileGrabbingWidget(user: _user!))),
            grabbingHeight: 60,
            sheetAbove: null,
            sheetBelow: SnappingSheetContent(
                // draggable: true,
                child: Material(
              child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 70, height: 70, child: _userImage),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _user!.email.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    ButtonTheme(
                                        minWidth: 20,
                                        height: 5,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.blue,
                                              shadowColor: Colors.blueAccent,
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32.0)),
                                              minimumSize: Size(50, 30),
                                            ),
                                            onPressed: _onChangeAvatar,
                                            child: Text('Change avatar')))
                                  ],
                                ),
                              ])))),
            )),
            child: widget.child));
  }

  Future<void> _onChangeAvatar() async {
    final imageFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      context
          .read<ProfileImageNotifier>()
          .updateNewProfileImage(imageFile.path);
    } else {
      _showNotSelectedSnackBar();
    }
  }

  void _showNotSelectedSnackBar() {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        content: const Text(
          'No image selected',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
