import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
