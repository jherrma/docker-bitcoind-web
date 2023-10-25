import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class ConnectionsSegment extends StatelessWidget {
  const ConnectionsSegment(
      {super.key,
      required this.connectionsIncoming,
      required this.connectionsOutgoing});

  final double textSize = 30;

  final int connectionsIncoming;
  final int connectionsOutgoing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Connections"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: textSize,
                  color: Colors.blue,
                ),
                Text(
                  "$connectionsIncoming in",
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  size: textSize,
                  color: Colors.green,
                ),
                Text(
                  "$connectionsOutgoing out",
                  style: TextStyle(
                    fontSize: textSize,
                    color: Colors.green,
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
