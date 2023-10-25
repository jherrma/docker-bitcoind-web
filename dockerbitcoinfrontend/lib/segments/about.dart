import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class AboutSegment extends StatelessWidget {
  const AboutSegment({super.key, required this.version, required this.chain});
  final double size = 30;

  final String version;
  final String chain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "About"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              version,
              style: TextStyle(
                fontSize: size,
                color: const Color.fromARGB(255, 242, 169, 0),
              ),
            ),
            Text(
              chain,
              style: TextStyle(
                fontSize: size,
                color: const Color.fromARGB(255, 242, 169, 0),
              ),
            )
          ],
        )
      ],
    );
  }
}
