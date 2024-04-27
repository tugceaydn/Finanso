import 'package:flutter/material.dart';
import 'package:negative_padding/negative_padding.dart';

import '../core/app_themes.dart';

class BlueSection extends StatelessWidget {
  const BlueSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NegativePadding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        color: primarySmoke,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: child,
        ),
      ),
    );
  }
}
