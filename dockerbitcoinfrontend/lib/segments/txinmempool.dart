import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class MempoolSegment extends StatelessWidget {
  const MempoolSegment({super.key, required this.txInMemPool});
  final double textSize = 30;
  final double spaceBetween = 15;

  final int txInMemPool;

  final int kilo = 1000;
  final int mega = 1000 * 1000;
  final int giga = 1000 * 1000 * 1000;

  final TextStyle defaultTextStyle = const TextStyle(
    fontSize: 30,
    color: Colors.blue,
  );

  // giga terra peta exa zetta yotta ronna
  Widget _getHashrateText(int txCount) {
    if (txCount < kilo) {
      return Row(
        children: [
          Text(
            "$txCount",
            style: defaultTextStyle,
          ),
          Text(
            " Tx",
            style: TextStyle(fontSize: textSize),
          )
        ],
      );
    }

    if (txCount < mega) {
      int thousands = txCount ~/ kilo;
      int houndreds = txCount % kilo;
      return Row(
        children: [
          Text(
            "$thousands,$houndreds",
            style: defaultTextStyle,
          ),
          Text(
            " Tx",
            style: TextStyle(fontSize: textSize),
          )
        ],
      );
    }

    int millions = txCount ~/ mega;
    int thousands = (txCount ~/ kilo) % kilo;
    int houndres = txCount % kilo;

    return Row(
      children: [
        Text(
          "$millions,$thousands,$houndres",
          style: defaultTextStyle,
        ),
        Text(
          " Tx",
          style: TextStyle(fontSize: textSize),
        )
      ],
    );
  }

  Widget _getTxInMemPoolTextElement(int txCount) {
    if (txCount == 0) {
      return Text(
        "Initializing...",
        style: TextStyle(fontSize: textSize),
      );
    }

    return _getHashrateText(txInMemPool);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Tx in Mempool"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _getTxInMemPoolTextElement(txInMemPool),
              ],
            )
          ],
        )
      ],
    );
  }
}
