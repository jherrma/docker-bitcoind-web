import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class BlockchainSegment extends StatelessWidget {
  const BlockchainSegment(
      {super.key,
      required this.blocks,
      required this.secondsSinceLatestBlock,
      required this.txInLatestBlock});
  final double textSize = 30;
  final double spaceBetween = 15;

  final int blocks;
  final int secondsSinceLatestBlock;
  final int txInLatestBlock;
  final TextStyle defaultTextStyle =
      const TextStyle(fontSize: 30, color: Colors.blue);

  final int minute = 60;
  final int hour = 3600;
  final int day = 3600 * 24;
  final int week = 3600 * 24 * 7;
  final int month = 3600 * 24 * 7 * 4;
  final int year = 3600 * 24 * 7 * 52;

  String _getNumberWithSeparator(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000 * 1000) {
      int low = number % 1000;
      int high = number ~/ 1000;
      return "$high,${_getHoundredsWithLeadingZeros(low)}";
    }

    int high = number ~/ (1000 * 1000);
    int mid = (number % 1000 * 1000) ~/ 1000;
    int low = number % 1000;
    return "$high,${_getHoundredsWithLeadingZeros(mid)},${_getHoundredsWithLeadingZeros(low)}";
  }

  String _getHoundredsWithLeadingZeros(int number) {
    if (number < 10) {
      return "00$number";
    } else if (number < 100) {
      return "0$number";
    } else {
      return number.toString();
    }
  }

  Widget _getBlockchainTextElement(int blocks) {
    if (blocks == 0) {
      return Text(
        "Initializing...",
        style: TextStyle(
          fontSize: textSize,
        ),
      );
    }

    return Row(children: [
      Text(
        _getNumberWithSeparator(blocks),
        style: defaultTextStyle,
      ),
      Text(
        " Blocks",
        style: TextStyle(fontSize: textSize),
      )
    ]);
  }

  Text _getReadableSecondsAgo(int secondsAgo) {
    if (secondsAgo < minute) {
      return _getDurationText(secondsAgo, "Second", "Seconds");
    }

    if (secondsAgo < hour) {
      int duration = secondsAgo ~/ minute;
      return _getDurationText(duration, "Minute", "Minutes");
    }

    if (secondsAgo < day) {
      int duration = secondsAgo ~/ hour;
      return _getDurationText(duration, "Hour", "Hours");
    }

    if (secondsAgo < week) {
      int duration = secondsAgo ~/ day;
      return _getDurationText(duration, "Day", "Days");
    }

    if (secondsAgo < month) {
      int duration = secondsAgo ~/ week;
      return _getDurationText(duration, "Week", "Weeks");
    }

    if (secondsAgo < year) {
      int duration = secondsAgo ~/ month;
      return _getDurationText(duration, "Month", "Months");
    }

    int duration = secondsAgo ~/ year;
    return _getDurationText(duration, "Year", "Years");
  }

  Text _getDurationText(int duration, String unitSingle, String unitMultiple) {
    if (duration == 1) {
      return Text(
        "$duration $unitSingle",
        style: defaultTextStyle,
      );
    }

    return Text(
      "$duration $unitMultiple",
      style: defaultTextStyle,
    );
  }

  Widget _getMinutsAgoTextElement(int minutesSinceLatestBlock) {
    if (minutesSinceLatestBlock == -1) {
      return Text(
        "Initializing...",
        style: TextStyle(
          fontSize: textSize,
        ),
      );
    }

    return Row(
      children: [
        _getReadableSecondsAgo(secondsSinceLatestBlock),
        Text(
          " ago",
          style: TextStyle(
            fontSize: textSize,
          ),
        )
      ],
    );
  }

  Widget _getTransactionsTextElement(int transactions) {
    if (transactions == -1) {
      return Text(
        "Initializing...",
        style: TextStyle(
          fontSize: textSize,
        ),
      );
    }

    return Row(
      children: [
        Text(
          _getNumberWithSeparator(txInLatestBlock),
          style: defaultTextStyle,
        ),
        Text(
          " Transactions",
          style: TextStyle(
            fontSize: textSize,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Blockchain"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_getBlockchainTextElement(blocks)],
        ),
        SizedBox(
          height: spaceBetween,
        ),
        const Headline(title: "Latest Block"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _getMinutsAgoTextElement(secondsSinceLatestBlock),
                SizedBox(
                  height: spaceBetween,
                ),
                _getTransactionsTextElement(txInLatestBlock)
              ],
            )
          ],
        )
      ],
    );
  }
}
