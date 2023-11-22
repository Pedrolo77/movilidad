import 'package:flutter/material.dart';
import 'package:movilidad/frames/mapa.dart';

import 'package:movilidad/frames/grafica_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
