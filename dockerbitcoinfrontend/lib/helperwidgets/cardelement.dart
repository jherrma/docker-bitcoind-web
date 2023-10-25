// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class CardElement extends StatelessWidget {
  const CardElement({super.key, required this.height, required this.child});
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: child,
        ),
      ),
    );
  }
}
