import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficaPage extends StatelessWidget {
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
        body: TabBarView(children: [DayTab(), DayTab(), DayTab(), DayTab()]),
      ),
    );
  }
}

class DayTab extends StatefulWidget {
  @override
  _DayTabState createState() => _DayTabState();
}

class _DayTabState extends State<DayTab> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Aquí puedes llamar a una función que genera la gráfica con la fecha seleccionada.
      // Por ejemplo:
      generatePopulationChart(selectedDate);
    }
  }

  void generatePopulationChart(DateTime selectedDate) {
    //Aquí deberías obtener los datos de población para la fecha seleccionada.
    // Por ahora, uso datos ficticios.

    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Container(
              height: 300,
              width: 300,
              child: showPopulationChart(),
            ),
          );
        }));
  }

  Widget showPopulationChart() {
    List<BarChartGroupData> barChartData = [
      BarChartGroupData(x: 0, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 150000000,
          toY: 130000000,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 1, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 130000000,
          toY: 120000000,
          color: Colors.green,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 2, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 120000000,
          toY: 100000000,
          color: Colors.orange,
          width: 20,
        ),
      ]),
    ];

    BarChart BC = BarChart(BarChartData(
      maxY: 200000000,
      minY: 50000000,
        barGroups: barChartData,
        gridData: FlGridData(show: false),
        groupsSpace: 12,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueAccent,
          ),
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: true)));

    return BC;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fecha seleccionada: ${selectedDate.toLocal()}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('Seleccionar fecha'),
        ),
      ],
    );
  }
}