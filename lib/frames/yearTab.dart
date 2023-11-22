import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/models/tuple.dart';

class YearTab extends StatefulWidget {
  @override
  _YearTabState createState() => _YearTabState();
}

class _YearTabState extends State<YearTab> {
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

      List<Tuple<int,int>> conexionesAno = List.empty(growable: true);
      conexionesAno = await getConexionesAno(selectedDate);
      generatePopulationChart(conexionesAno);
    }
  }

  Future<List<Tuple<int,int>>> getConexionesAno(selectedDate) async {
    DB database = DB();
    return await database.getConexionesAno(selectedDate);
  }

  void generatePopulationChart(List<Tuple<int,int>> conexiones) {
    //Aquí deberías obtener los datos de población para la fecha seleccionada.
    // Por ahora, uso datos ficticios.

    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Container(
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
          toY: e.elem2 as double,
          color: Colors.blue,
          width: 20,
        ),
      ])).toList();

    BarChart BC = BarChart(BarChartData(
      maxY: 10000,
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