import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';
import 'package:flutter/material.dart';

class Uptime extends StatelessWidget {
  const Uptime({super.key, required this.uptime});

  final double textSize = 30;
  final int uptime;

  final int minute = 60;
  final int hour = 3600;
  final int day = 3600 * 24;
  final int week = 3600 * 24 * 7;
  final int month = 3600 * 24 * 7 * 4;
  final int year = 3600 * 24 * 7 * 52;

  final TextStyle defaultTextStyle =
      const TextStyle(fontSize: 30, color: Colors.blue);

  Text _getUptimeText(int uptime) {
    if (uptime < minute) {
      return Text(
        "$uptime Seconds",
        style: defaultTextStyle,
      );
    } else if (uptime < hour) {
      int minutes = uptime ~/ minute;
      if (minutes == 1) {
        return Text(
          "$minutes Minute",
          style: defaultTextStyle,
        );
      }

      return Text(
        "$minutes Minutes",
        style: defaultTextStyle,
      );
    } else if (uptime < day) {
      int hours = uptime ~/ hour;
      if (hours == 1) {
        return Text(
          "$hours Hour",
          style: defaultTextStyle,
        );
      }

      return Text(
        "$hours Hours",
        style: defaultTextStyle,
      );
    } else if (uptime < week) {
      int days = uptime ~/ day;
      if (days == 1) {
        return Text(
          "$days Day",
          style: defaultTextStyle,
        );
      }

      return Text(
        "$days Days",
        style: defaultTextStyle,
      );
    } else if (uptime < month) {
      int weeks = uptime ~/ week;
      if (weeks == 1) {
        return Text(
          "$weeks Week",
          style: defaultTextStyle,
        );
      }

      return Text(
        "$weeks Weeks",
        style: defaultTextStyle,
      );
    } else if (uptime < year) {
      int months = uptime ~/ month;
      if (months == 1) {
        return Text(
          "$months Month",
          style: defaultTextStyle,
        );
      }

      return Text(
        "$months Months",
        style: defaultTextStyle,
      );
    }

    int years = uptime ~/ year;
    if (years == 1) {
      return Text(
        "$years Year",
        style: defaultTextStyle,
      );
    }

    return Text(
      "$years Years",
      style: defaultTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Uptime"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_getUptimeText(uptime)],
        )
      ],
    );
  }
}
