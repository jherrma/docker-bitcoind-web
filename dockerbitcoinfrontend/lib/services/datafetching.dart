import 'dart:convert';

import 'package:dockerbitcoinfrontend/models/datafetchingresult.dart';
import 'package:http/http.dart' as http;

import 'package:dockerbitcoinfrontend/models/bitcoindata.dart';

class DataFetching {
  static http.Client? client;

  static Future<DataFetchingResult> getBitcoinData() async {
    try {
      client ??= http.Client();

      var requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      var uri = Uri.parse("/api/collectedinfo");
      var response = await client!.get(uri, headers: requestHeaders);

      var body = response.body;

      if (response.statusCode != 200) {
        return DataFetchingResult(
            bitcoinData: null,
            errorMessage: "Could not fetch data due to $body",
            isError: true);
      }

      var bitcoinData = BitcoinData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);

      return DataFetchingResult(
          bitcoinData: bitcoinData, errorMessage: "", isError: false);
    } catch (ex) {
      return DataFetchingResult(
          bitcoinData: null, errorMessage: ex.toString(), isError: true);
    }
  }
}
