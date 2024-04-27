import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/styled_button.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledButton(
      handlePress: () => FirebaseAuth.instance.signOut(),
      text: 'Sign out',
      type: 'secondary',
    );
  }
}
