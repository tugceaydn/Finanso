import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/styled_button.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';

import '../core/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  User? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  Widget profilePicture() {
    List<String>? nameParts = user?.displayName!.split(' ');
    String initials = '';

    for (int i = 0; i < nameParts!.length && i < 2; i++) {
      initials += nameParts[i][0].toUpperCase();
    }

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: primarySmoke,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: primary,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: StyledText(text: initials, type: 'title', color: textPrimary),
      ),
    );
  }

  Widget readOnlyTextField() {
    return TextFormField(
      readOnly: true,
      enabled: false,
      initialValue: user!.email,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: textPrimary,
          ),
    );
  }

  Widget profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'Profile',
          type: 'header',
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profilePicture(),
            const SizedBox(
              width: 16,
            ),
            StyledText(
              text: '${user?.displayName}',
              type: 'title',
            ),
          ],
        ),
        const SizedBox(height: 16),
        readOnlyTextField(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profile(),
        const SizedBox(height: 32),
        StyledButton(
          handlePress: () => FirebaseAuth.instance.signOut(),
          text: 'Sign out',
          type: 'secondary',
        ),
      ],
    );
  }
}
