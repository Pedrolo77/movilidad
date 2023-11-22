import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/models/tuple.dart';

class MonthTab extends StatefulWidget {
  const MonthTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonthTabState createState() => _MonthTabState();
}

class _MonthTabState extends State<MonthTab> {
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

      List<Tuple<int,int>> conexionesMes = List.empty(growable: true);
      conexionesMes = await getConexionesMes(selectedDate);
      generatePopulationChart(conexionesMes);
    }
  }

  Future<List<Tuple<int,int>>> getConexionesMes(selectedDate) async {
    DB database = DB();
    return await database.getConexionesMes(selectedDate);
  }

  void generatePopulationChart(List<Tuple<int,int>> conexiones) {
    //Aquí deberías obtener los datos de población para la fecha seleccionada.
    // Por ahora, uso datos ficticios.

    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              width: 300,
              child: showPopulationChart(conexiones),
            ),
          );
        }));
  }

  Widget showPopulationChart(List<Tuple<int,int>> conexiones) {

    List<BarChartGroupData> barChartData = conexiones.map((e) => BarChartGroupData(x: e.elem1, barsSpace: 8, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: 0.0 + e.elem2,
          color: Colors.blue,
          width: 5,
        ),
      ])).toList();

    BarChart bC = BarChart(BarChartData(
      maxY: 100,
      minY: 0,
        barGroups: barChartData,
        gridData: const FlGridData(show: false),
        groupsSpace: 40,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueAccent,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: true)));

    return bC;
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
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Seleccionar fecha'),
        ),
      ],
    );
  }
}