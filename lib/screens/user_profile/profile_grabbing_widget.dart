import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileGrabbingWidget extends StatelessWidget {
  User user;
  ProfileGrabbingWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome back, ${user.email.toString()}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const Icon(Icons.keyboard_arrow_up)
            ],
          )),
    );
  }
}
