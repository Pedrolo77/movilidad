import 'package:flutter/material.dart';
import 'package:movilidad/frames/day_tab.dart';
import 'package:movilidad/frames/month_tab.dart';
import 'package:movilidad/frames/weekTab.dart';
import 'package:movilidad/frames/yearTab.dart';
import 'package:movilidad/models/parada.dart';

class GraficaPage extends StatelessWidget {
  List<Parada> Pi = List.empty(growable: true);
  GraficaPage({super.key, required P}){
  Pi = P;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Dia'),
              ),
              Tab(
                child: Text('Semana'),
              ),
              Tab(
                child: Text('Mes'),
              ),
              Tab(
                child: Text('Año'),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [DayTab(P: Pi), WeekTab(), MonthTab(), YearTab()]),
      ),
    );
  }
}

