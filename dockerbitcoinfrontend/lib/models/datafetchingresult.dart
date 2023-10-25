import 'package:dockerbitcoinfrontend/models/bitcoindata.dart';

class DataFetchingResult {
  BitcoinData? bitcoinData;
  String errorMessage;
  bool isError;

  DataFetchingResult(
      {required this.bitcoinData,
      required this.errorMessage,
      required this.isError});
}
