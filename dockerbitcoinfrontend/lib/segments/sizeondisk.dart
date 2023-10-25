import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/headline.dart';

class SizeOnDisk extends StatelessWidget {
  const SizeOnDisk({super.key, required this.sizeOnDiskInMb});

  final double textSize = 30;
  final int gigabyte = 1000;
  final int terrabyte = 1000 * 1000;

  final int sizeOnDiskInMb;

  String _getSizeOnDiskString() {
    if (sizeOnDiskInMb < gigabyte) {
      return "$sizeOnDiskInMb MB";
    } else if (sizeOnDiskInMb < terrabyte) {
      int gb = sizeOnDiskInMb ~/ gigabyte;
      return "$gb GB";
    } else {
      int tb = sizeOnDiskInMb ~/ terrabyte;
      return "$tb TB";
    }
  }

  Text _getSizeOnDiskTextElement(int blocks) {
    if (blocks == 0) {
      return Text(
        "Initializing...",
        style: TextStyle(fontSize: textSize),
      );
    }

    return Text(
      _getSizeOnDiskString(),
      style: TextStyle(
        fontSize: textSize,
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Headline(title: "Size on Disk"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_getSizeOnDiskTextElement(sizeOnDiskInMb)],
        )
      ],
    );
  }
}
