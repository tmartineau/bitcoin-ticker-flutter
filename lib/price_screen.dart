import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  CoinData coinData = CoinData();
  Map<String, double> priceData = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> currencies = [];

    for (String currency in currenciesList) {
      currencies.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencies,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getPrices();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> currencies = [];

    for (String currency in currenciesList) {
      currencies.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currencies[selectedIndex].data;
          getPrices();
        });
      },
      children: currencies,
    );
  }

  void getPrices() async {
    var prices = await coinData.loadAllPrices(selectedCurrency);
    setState(() {
      priceData = prices;
    });
  }

  List<Widget> getPriceList() {
    List<Widget> priceList = [];

    for (String crypto in cryptoList) {
      priceList.add(CoinPrice(
        coinCode: crypto,
        fiatCode: selectedCurrency,
        lastPrice: priceData[crypto],
      ));
    }

    return priceList;
  }

  @override
  void initState() {
    super.initState();
    getPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getPriceList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinPrice extends StatelessWidget {
  CoinPrice({this.lastPrice, this.coinCode, this.fiatCode});

  final double lastPrice;
  final String coinCode;
  final String fiatCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinCode = ${lastPrice ?? '?'} $fiatCode',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
