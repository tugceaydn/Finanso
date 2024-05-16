import 'package:flutter/material.dart';

import '../core/app_themes.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: primary));
  }
}
