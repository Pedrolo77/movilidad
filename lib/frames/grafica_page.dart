import 'package:flutter/material.dart';
import 'package:movilidad/frames/day_tab.dart';
import 'package:movilidad/frames/month_tab.dart';
import 'package:movilidad/frames/weekTab.dart';
import 'package:movilidad/frames/yearTab.dart';

class GraficaPage extends StatelessWidget {
  const GraficaPage({super.key});

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
        body: TabBarView(children: [const DayTab(), WeekTab(), MonthTab(), YearTab()]),
      ),
    );
  }
}

