import 'package:flutter/material.dart';

class NetflixLogo extends StatelessWidget {
  const NetflixLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(
          height: 32,
          width: 100,
        );
      },
    );
  }
}

