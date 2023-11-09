import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:movilidad/mapa.dart';

import 'graficaPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Mapa(),
        '/grafica': (BuildContext context) => GraficaPage()
      },
    );
  }
}
