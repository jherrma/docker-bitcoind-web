import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class Syncronized extends StatelessWidget {
  const Syncronized({super.key, required this.verificationProgress});

  final double textSize = 30;

  final double verificationProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Verification"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${(verificationProgress * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: textSize,
                color: verificationProgress >= 0.99
                    ? Colors.green
                    : const Color.fromARGB(255, 242, 169, 0),
              ),
            ),
          ],
        )
      ],
    );
  }
}
