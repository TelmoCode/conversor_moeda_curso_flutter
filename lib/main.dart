import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request =
    'https://api.hgbrasil.com/finance?format=json-cors&key=cf4bc754';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.amber,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControler = TextEditingController();
  final dolarControler = TextEditingController();
  final euroControler = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarControler.text = (real/dolar).toStringAsFixed(2);
    euroControler.text = (real/euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realControler.text = (dolar*this.dolar).toStringAsFixed(2);
    euroControler.text = (dolar*this.dolar/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realControler.text = (euro*this.euro).toStringAsFixed(2);
    dolarControler.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('\$ Conversor de Moedas \$'),
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando Dados",
                      style: TextStyle(color: Colors.amber),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao carregar dados",
                        style: TextStyle(color: Colors.amber),
                      ),
                    );
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]['buy'];
                    euro = snapshot.data["results"]["currencies"]["EUR"]['buy'];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          BuildTextField(
                              "Reais", "R\$  ", realControler, _realChanged),
                          Divider(),
                          BuildTextField("Dolares", "US\$  ", dolarControler,
                              _dolarChanged),
                          Divider(),
                          BuildTextField(
                              "Euros", "€  ", euroControler, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget BuildTextField(String label, String prefix,
    TextEditingController controller, Function changed) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: prefix,
      border: OutlineInputBorder(),
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: changed,
    keyboardType: TextInputType.number,
  );
}
