import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_buttons.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Profile",
          back: false,
        ),
      ),
      body: Column(
        children: [
          OlxButton(
              color: Colors.red,
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              text: "Log Out")
        ],
      ),
    );
  }
}
