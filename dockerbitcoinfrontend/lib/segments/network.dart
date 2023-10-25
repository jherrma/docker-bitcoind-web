import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class MempoolSegment extends StatelessWidget {
  const MempoolSegment({super.key, required this.gigaHashesPerSecond});
  final double textSize = 30;
  final double spaceBetween = 15;

  final int gigaHashesPerSecond;

  final int kilo = 1000;
  final int mega = 1000 * 1000;
  final int giga = 1000 * 1000 * 1000;

  final int terraBaseGiga = 1000;
  final int exaBaseGiga = 1000 * 1000;
  final int zettaBaseGiga = 1000 * 1000 * 1000;
  final int yottaBaseGiga = 1000 * 1000 * 1000 * 1000;
  final int ronnaBaseGiga = 1000 * 1000 * 1000 * 1000 * 1000;

  final TextStyle defaultTextStyle = const TextStyle(
    fontSize: 30,
    color: Colors.blue,
  );

  // giga terra peta exa zetta yotta ronna
  Text _getHashrateText(int gigaHashesPerSecond) {
    if (gigaHashesPerSecond < terraBaseGiga) {
      return Text(
        "$gigaHashesPerSecond GH/s",
        style: defaultTextStyle,
      );
    }

    if (gigaHashesPerSecond < exaBaseGiga) {
      int terraHashes = gigaHashesPerSecond ~/ terraBaseGiga;
      return Text(
        "$terraHashes TH/s",
        style: defaultTextStyle,
      );
    }

    if (gigaHashesPerSecond < zettaBaseGiga) {
      int exaHashes = gigaHashesPerSecond ~/ exaBaseGiga;
      return Text(
        "$exaHashes EH/s",
        style: defaultTextStyle,
      );
    }

    if (gigaHashesPerSecond < yottaBaseGiga) {
      int zettaHashes = gigaHashesPerSecond ~/ zettaBaseGiga;
      return Text(
        "$zettaHashes ZH/s",
        style: defaultTextStyle,
      );
    }

    int yottaHashes = gigaHashesPerSecond ~/ yottaBaseGiga;
    return Text(
      "$yottaHashes YH/s",
      style: defaultTextStyle,
    );
  }

  Widget _getHashrateTextElement(int hashrate) {
    if (hashrate == 0) {
      return Text(
        "Initializing...",
        style: TextStyle(fontSize: textSize),
      );
    }

    return _getHashrateText(gigaHashesPerSecond);
  }

  Widget getFeeText(double txFee) {
    return Row(
      children: [
        Text(
          "Fees: ",
          style: TextStyle(fontSize: textSize),
        ),
        Text(
          "${txFee.toStringAsFixed(5)} BTC / Tx",
          style: defaultTextStyle,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Network"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _getHashrateTextElement(gigaHashesPerSecond),
              ],
            )
          ],
        )
      ],
    );
  }
}
