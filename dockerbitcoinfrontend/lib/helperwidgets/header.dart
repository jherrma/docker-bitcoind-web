import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      child: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: Image(image: AssetImage("assets/bitcoin-logo.png"))),
    );
  }
}
