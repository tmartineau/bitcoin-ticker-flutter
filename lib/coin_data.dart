import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'BCH',
  'ETH',
  'LTC',
];

class CoinData {
  Future loadAllPrices(String currency) async {
    Map<String, double> priceData = {};

    String clist = cryptoList.join(',');
    http.Response res = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/short?crypto=$clist&fiat=$currency');

    if (res.statusCode >= 200 && res.statusCode < 400) {
      var json = jsonDecode(res.body);

      for (String crypto in cryptoList) {
        double last =
            double.parse(json['$crypto$currency']['last'].toStringAsFixed(2));
        priceData[crypto] = last;
      }
      return priceData;
    }
  }
}
