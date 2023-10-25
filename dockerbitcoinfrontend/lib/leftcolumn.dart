import 'package:flutter/material.dart';

import 'package:dockerbitcoinfrontend/models/bitcoindata.dart';
import 'package:dockerbitcoinfrontend/segments/sizeondisk.dart';
import 'package:dockerbitcoinfrontend/segments/synchronized.dart';
import 'package:dockerbitcoinfrontend/segments/blockchain.dart';
import 'package:dockerbitcoinfrontend/helperwidgets/cardelement.dart';

class LeftColumn extends StatelessWidget {
  const LeftColumn(
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
            child: Syncronized(
                verificationProgress: bitcoinData.verificationProgress),
          ),
          CardElement(
            height: heightSmall,
            child: SizeOnDisk(sizeOnDiskInMb: bitcoinData.sizeOnDiskInMb),
          ),
          CardElement(
            height: heightLarge,
            child: BlockchainSegment(
                blocks: bitcoinData.blocks,
                secondsSinceLatestBlock: bitcoinData.secondsSinceLatestBlock,
                txInLatestBlock: bitcoinData.txInLatestBlock),
          ),
        ],
      ),
    );
  }
}
