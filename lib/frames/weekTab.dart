import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';

class WeekTab extends StatefulWidget {
  @override
  _WeekTabState createState() => _WeekTabState();
}

class _WeekTabState extends State<WeekTab> {
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

      List<int> conexionesSemana = List.empty(growable: true);
      conexionesSemana = await getConexionesSemana(selectedDate);
      generatePopulationChart(conexionesSemana);
    }
  }

  Future<List<int>> getConexionesSemana(selectedDate) async {
    DB database = DB();
    return await database.getConexionesSemana(selectedDate);
  }

  void generatePopulationChart(List<int> conexionesSemana) {
    //Aquí deberías obtener los datos de población para la fecha seleccionada.
    // Por ahora, uso datos ficticios.

    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Container(
              height: 300,
              width: 300,
              child: showPopulationChart(conexionesSemana),
            ),
          );
        }));
  }

  Widget showPopulationChart(List<int> conexionesSemana) {
    List<BarChartGroupData> barChartData = [
      BarChartGroupData(x: 0, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[0] as double,
          color: Colors.blue,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 1, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[1] as double,
          color: Colors.green,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 2, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[2] as double,
          color: Colors.orange,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 3, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[3] as double,
          color: Colors.orange,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 4, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[4] as double,
          color: Colors.orange,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 5, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[5] as double,
          color: Colors.orange,
          width: 20,
        ),
      ]),
      BarChartGroupData(x: 6, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: conexionesSemana[6] as double,
          color: Colors.orange,
          width: 20,
        ),
      ]),
    ];

    BarChart BC = BarChart(BarChartData(
      maxY: 5000,
      minY: 0,
        barGroups: barChartData,
        gridData: FlGridData(show: false),
        groupsSpace: 60,
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