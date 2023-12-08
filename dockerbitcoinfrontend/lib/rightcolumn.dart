import 'package:dockerbitcoinfrontend/segments/uptime.dart';
import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/models/bitcoindata.dart';
import 'package:dockerbitcoinfrontend/segments/connections.dart';
import 'package:dockerbitcoinfrontend/segments/txinmempool.dart';
import 'package:dockerbitcoinfrontend/segments/about.dart';
import 'package:dockerbitcoinfrontend/helperwidgets/cardelement.dart';

class RightColumn extends StatelessWidget {
  const RightColumn(
      {super.key,
      required this.heightSmall,
      required this.heightLarge,
      required this.bitcoinData});

  final double heightSmall;
  final double heightLarge;
  final BitcoinData bitcoinData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CardElement(
            height: heightSmall,
            child: ConnectionsSegment(
                connectionsIncoming: bitcoinData.connectionsIncoming,
                connectionsOutgoing: bitcoinData.connectionsOutgoing),
          ),
          CardElement(
            height: heightSmall,
            child: MempoolSegment(
              txInMemPool: bitcoinData.txInMemPool,
            ),
          ),
          CardElement(
            height: heightSmall,
            child: Uptime(uptime: bitcoinData.uptime),
          ),
          CardElement(
            height: heightSmall,
            child: AboutSegment(
              version: bitcoinData.version,
              chain: bitcoinData.chain,
            ),
          ),
        ],
      ),
    );
  }
}
