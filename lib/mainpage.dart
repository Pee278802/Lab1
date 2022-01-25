import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MainPage());

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Currency Converter'),
          ),
          body: Column(
            children: const [
              SizedBox(height: 10),
              Flexible(
                flex: 3,
                child: Converter(),
              )
            ],
          )),
    );
  }
}

class Converter extends StatefulWidget {
  const Converter({Key? key}) : super(key: key);

  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  TextEditingController inputEditingController = TextEditingController();
  TextEditingController outputEditingController = TextEditingController();
  double input = 0.0, output = 0.0, inputCurrency = 0.0, outputCurrency = 0.0;
  String desc = "";
  String currencySelection1 = "MYR";
  String currencySelection2 = "USD";

  List<String> currencyList = [
    "GBP",
    "EUR",
    "USD",
    "MYR",
    "JPY",
    "BRL",
    "CNY",
    "KRW",
  ];

  _convert() async {
    var apiId = "7f57b190-39fa-11ec-88a6-b597b9073ac8";
    var url =
        Uri.parse('https://freecurrencyapi.net/api/v2/latest?apikey=$apiId');
    var response = await http.get(url);
    var rescode = response.statusCode;

    setState(() {
      if (rescode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);

        if (currencySelection1 == "USD") {
          inputCurrency = 1.0;
        } else {
          inputCurrency = parsedJson['data'][currencySelection1];
        }

        if (currencySelection2 == "USD") {
          outputCurrency = 1.0;
        } else {
          outputCurrency = parsedJson['data'][currencySelection2];
        }

        desc = "";
      } else {
        desc = "No data";
      }

      if (inputEditingController.text != "") {
        input = double.parse(inputEditingController.text);
        output = (input / inputCurrency) * outputCurrency;
        outputEditingController.text = output.toString();
      } else {
        outputEditingController.text = "";
        input = 0.0;
        output = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: inputEditingController,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(),
                      onChanged: (newValue) {
                        _convert();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownButton(
                      itemHeight: 60,
                      value: currencySelection1,
                      onChanged: (newValue) {
                        currencySelection1 = newValue.toString();
                        _convert();
                      },
                      items: currencyList.map((currencySelection1) {
                        return DropdownMenuItem(
                          child: Text(
                            currencySelection1,
                          ),
                          value: currencySelection1,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: outputEditingController,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DropdownButton(
                        itemHeight: 60,
                        value: currencySelection2,
                        items: currencyList.map((selectCur2) {
                          return DropdownMenuItem(
                            child: Text(
                              selectCur2,
                            ),
                            value: selectCur2,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          currencySelection2 = newValue.toString();
                          _convert();
                        }),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: 280,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.indigo.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        input.toString() +
                            " " +
                            currencySelection1 +
                            " = " +
                            output.toString() +
                            " " +
                            currencySelection2,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(desc),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
