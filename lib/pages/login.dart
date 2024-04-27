import 'package:flutter/material.dart';
import 'package:stock_market/core/app_themes.dart';

import '../components/logo.dart';
import '../components/styled_button.dart';
import '../components/styled_input.dart';
import '../components/styled_text.dart';
import '../main.dart';
import '../user_auth/auth_services.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
  }

  Widget loginForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                text: 'You don\'t have an account?',
                type: 'functional',
              ),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                onTap: () {
                  navigatorKey.currentState?.push(
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                child: const Text(
                  'Create one',
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

  Widget loginButtons() {
    return Column(
      children: [
        StyledButton(
          handlePress: () => AuthService().signInWithEmail(
            emailAddress: _emailInputController.text,
            password: _passwordInputController.text,
          ),
          text: 'Log in',
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
          text: 'Sign in with Google',
          type: 'secondary',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 32),
            const StyledText(text: 'Login', type: 'title_bold'),
            const SizedBox(height: 70),
            loginForm(),
            const SizedBox(height: 64),
            loginButtons(),
          ],
        ),
        const Positioned(
          bottom: 32,
          child: Logo(),
        ),
      ],
    );
  }
}
