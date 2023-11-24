import 'package:flutter/material.dart';
import 'package:movilidad/frames/day_tab.dart';
import 'package:movilidad/frames/mapa.dart';

import 'package:movilidad/frames/grafica_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
   MyApp({super.key});
MaterialColor purpleBlue = MaterialColor(
  0xFF6A00FF,
  <int, Color>{
    50: Color(0xFFE8D8FF),
    100: Color(0xFFD1B1FF),
    200: Color(0xFFB98AFF),
    300: Color(0xFFA263FF),
    400: Color(0xFF8B3CFF),
    500: Color(0xFF6A00FF),
    600: Color(0xFF5500DB),
    700: Color(0xFF4000B7),
    800: Color(0xFF2B0083),
    900: Color(0xFF16005F),
  },
);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
                primarySwatch: purpleBlue,
              ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Mapa(),
        '/grafica': (BuildContext context) => GraficaPage(P: List.empty()),
        '/dayTab': (BuildContext context) => DayTab(P: List.empty(),)
      },
    );
  }
}
