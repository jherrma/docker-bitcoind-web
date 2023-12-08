import 'dart:async';

import 'package:dockerbitcoinfrontend/models/bitcoindata.dart';
import 'package:dockerbitcoinfrontend/services/datafetching.dart';
import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/helperwidgets/header.dart';
import 'package:dockerbitcoinfrontend/leftcolumn.dart';
import 'package:dockerbitcoinfrontend/rightcolumn.dart';

void main() {
  runApp(const BitcoindMontoringApp());
}

class BitcoindMontoringApp extends StatelessWidget {
  const BitcoindMontoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin Node',
      theme: ThemeData.dark(useMaterial3: true),
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final double defaultWidth = 1200;
  final double heightSmall = 150;
  final double heightLarge = 300;
  final BitcoinData defaultBitcoinData = BitcoinData(
      sizeOnDiskInMb: 0,
      blocks: 0,
      secondsSinceLatestBlock: -1,
      txInLatestBlock: -1,
      verificationProgress: 0,
      connectionsIncoming: 0,
      connectionsOutgoing: 0,
      txInMemPool: 0,
      uptime: 0,
      version: "-",
      chain: "-");

  Timer? timer;
  bool fetchingBitcoinData = false;
  bool isError = false;
  String errorMessage = "";

  BitcoinData bitcoinData = BitcoinData(
      sizeOnDiskInMb: 0,
      blocks: 0,
      secondsSinceLatestBlock: -1,
      txInLatestBlock: -1,
      verificationProgress: 0,
      connectionsIncoming: 0,
      connectionsOutgoing: 0,
      txInMemPool: 0,
      uptime: 0,
      version: "-",
      chain: "-");

  @override
  void initState() {
    super.initState();
    _setTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _setTimer() {
    int delaySeconds = 3;

    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: delaySeconds), (timer) async {
      // in case, the fetching takes longer than the interval
      if (fetchingBitcoinData) {
        return;
      }
      fetchingBitcoinData = true;

      var result = await DataFetching.getBitcoinData();

      setState(() {
        isError = result.isError;
        errorMessage = result.errorMessage;
        bitcoinData = result.bitcoinData ?? defaultBitcoinData;
      });

      fetchingBitcoinData = false;
    });
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }

  Widget? _bottmSheet() {
    if (!isError) {
      return null;
    }

    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(errorMessage),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: min(screenWidth, defaultWidth),
              child: Column(
                children: [
                  const Header(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LeftColumn(
                        heightSmall: heightSmall,
                        heightLarge: heightLarge,
                        bitcoinData: bitcoinData,
                      ),
                      RightColumn(
                        heightSmall: heightSmall,
                        heightLarge: heightLarge,
                        bitcoinData: bitcoinData,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _bottmSheet(),
    );
  }
}
