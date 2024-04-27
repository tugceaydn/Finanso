import 'package:flutter/material.dart';

import '../core/app_themes.dart';
import 'styled_text.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        StyledText(
          text: 'Fin',
          type: 'header',
          color: primary,
        ),
        StyledText(text: 'anso', type: 'header'),
      ],
    );
  }
}
