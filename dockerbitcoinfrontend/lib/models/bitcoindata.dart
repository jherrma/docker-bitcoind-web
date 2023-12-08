class BitcoinData {
  int sizeOnDiskInMb;
  int blocks;
  int secondsSinceLatestBlock;
  int txInLatestBlock;
  double verificationProgress;
  int connectionsIncoming;
  int connectionsOutgoing;
  int txInMemPool;
  int uptime;
  String version;
  String chain;

  BitcoinData(
      {required this.sizeOnDiskInMb,
      required this.blocks,
      required this.secondsSinceLatestBlock,
      required this.txInLatestBlock,
      required this.verificationProgress,
      required this.connectionsIncoming,
      required this.connectionsOutgoing,
      required this.txInMemPool,
      required this.uptime,
      required this.version,
      required this.chain});

  factory BitcoinData.fromJson(Map<String, dynamic> json) {
    return BitcoinData(
        sizeOnDiskInMb: json["sizeOnDiskInMb"] as int,
        blocks: json["blocks"] as int,
        secondsSinceLatestBlock: json["secondsSinceLatestBlock"] as int,
        txInLatestBlock: json["txInLatestBlock"] as int,
        verificationProgress: json["verificationProgress"] as double,
        connectionsIncoming: json["connectionsIncoming"] as int,
        connectionsOutgoing: json["connectionsOutgoing"] as int,
        txInMemPool: json["txInMemPool"] as int,
        uptime: json["uptime"] as int,
        version: json["version"] as String,
        chain: json["chain"] as String);
  }
}
