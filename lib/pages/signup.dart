import 'package:flutter/material.dart';
import 'package:stock_market/components/wrapper.dart';

import '../components/logo.dart';
import '../components/styled_button.dart';
import '../components/styled_input.dart';
import '../components/styled_text.dart';
import '../core/app_themes.dart';
import '../main.dart';
import '../user_auth/auth_services.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _nameInputController;
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
  }

  Widget signupForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(text: 'Name'),
          const SizedBox(height: 8),
          StyledInput(
            controller: _nameInputController,
            hint: 'Emir Tugce',
          ),
          const SizedBox(height: 32),
          const StyledText(text: 'Email'),
          const SizedBox(height: 8),
          StyledInput(
            controller: _emailInputController,
            hint: 'finanso-app@gmail.com',
          ),
          const SizedBox(height: 32),
          const StyledText(text: 'Password'),
          const SizedBox(height: 8),
          StyledInput(
            controller: _passwordInputController,
            isPassword: true,
            hint: '*************',
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const StyledText(
                text: 'You already have an account?',
                type: 'functional',
              ),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {
                  navigatorKey.currentState?.pop(context);
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: 'San Francisco',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: primary,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget signUpButtons() {
    return Column(
      children: [
        StyledButton(
          handlePress: () => AuthService().signUpWithEmailAndPassword(
            name: _nameInputController.text,
            email: _emailInputController.text,
            password: _passwordInputController.text,
          ),
          text: 'Sign up',
          isActive: true,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(height: 1, color: textSmoke),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 31.0),
              child: StyledText(
                text: 'or',
                type: 'body_smoke',
              ),
            ),
            Expanded(
              child: Container(height: 1, color: textSmoke),
            ),
          ],
        ),
        const SizedBox(height: 32),
        StyledButton(
          handlePress: () => AuthService().signInWithGoogle(),
          text: 'Sign up with Google',
          type: 'secondary',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 32),
              const StyledText(text: 'Signup', type: 'title_bold'),
              const SizedBox(height: 70),
              signupForm(),
              const SizedBox(height: 64),
              signUpButtons(),
            ],
          ),
          const Positioned(
            bottom: 32,
            child: Logo(),
          ),
        ],
      ),
    );
  }
}
