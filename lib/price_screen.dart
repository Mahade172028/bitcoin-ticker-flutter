import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'network.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrnecy="USD";
  var btcCurrencyRate=0.0;
  var ethCurrencyRate=0.0;
  var ltcCurrencyRate=0.0;
  Network network=Network();

  DropdownButton<String> androidDropdownButton(){
        List<DropdownMenuItem<String>> dropdownItemsList=[];
        for (String txt in currenciesList){
          var newItem=DropdownMenuItem<String>(
            child: Text(txt),
            value: txt,
          );
          dropdownItemsList.add(newItem);
        }
    return  DropdownButton<String>(
      value:selectedCurrnecy,
      items:dropdownItemsList,
      onChanged: (value){
      setState(() {
      selectedCurrnecy=value;
      getCurrency(selectedCurrnecy);
      });
      },
      );
  }

  CupertinoPicker iosPicker(){

    List<Text> pickerItems=[];
    for (String txt in currenciesList){
      var newItem=Text(txt);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  void getCurrency(String fromCoin) async{
    var rateBTC= await network.getCurrencyExchangeRate('BTC', fromCoin);
    var rateETH= await network.getCurrencyExchangeRate('ETH', fromCoin);
    var rateLTC= await network.getCurrencyExchangeRate('LTC', fromCoin);
    //print(rate);
    setState((){
      btcCurrencyRate=rateBTC;
      ethCurrencyRate=rateETH;
      ltcCurrencyRate=rateLTC;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrency('USD');
  }



  @override
  Widget build(BuildContext context) {
    //getCurrency();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ReuseableWidget(currencyRate: btcCurrencyRate, selectedCurrnecy: selectedCurrnecy,fromCurrency: 'BTC',),
          ReuseableWidget(currencyRate: ethCurrencyRate, selectedCurrnecy: selectedCurrnecy,fromCurrency: 'ETH',),
          ReuseableWidget(currencyRate: ltcCurrencyRate, selectedCurrnecy: selectedCurrnecy,fromCurrency: 'LTC',),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS?iosPicker():androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  const ReuseableWidget({
    Key key,
    @required this.currencyRate,
    @required this.selectedCurrnecy,
    @required this.fromCurrency,
  }) : super(key: key);

  final double currencyRate;
  final String selectedCurrnecy;
  final String fromCurrency;

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
            '1 $fromCurrency = $currencyRate $selectedCurrnecy',
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

