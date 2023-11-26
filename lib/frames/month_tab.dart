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
              height: 500,
              width: 500,
              child: showPopulationChart(conexiones),
            ),
          );
        }));
  }

  Widget showPopulationChart(List<Tuple<int,int>> conexiones) {
    const barsSpace = 4.0 * 500 / 400;
    const barsWidth = 8.0 * 500 / 400;

    Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
        case 5:
        text = '5';
        break;
        case 6:
        text = '6';
        break;
        case 7:
        text = '7';
        break;
        case 8:
        text = '8';
        break;
        case 9:
        text = '9';
        break;
        case 10:
        text = '10';
        break;
        case 11:
        text = '11';
        break;
        case 12:
        text = '12';
        break;
        case 13:
        text = '13';
        break;
        case 14:
        text = '14';
        break;
        case 15:
        text = '15';
        break;
        case 16:
        text = '16';
        break;
        case 17:
        text = '17';
        break;
        case 18:
        text = '18';
        break;
        case 19:
        text = '19';
        break;
        case 20:
        text = '20';
        break;
        case 21:
        text = '21';
        break;
        case 22:
        text = '22';
        break;
        case 23:
        text = '23';
        break;
        case 24:
        text = '24';
        break;
        case 25:
        text = '25';
        break;
        case 26:
        text = '26';
        break;
        case 27:
        text = '27';
        break;
        case 28:
        text = '28';
        break;
        case 29:
        text = '29';
        break;
        case 30:
        text = '30';
        break;
        case 31:
        text = '31';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

    List<BarChartGroupData> barChartData = conexiones.map((e) => BarChartGroupData(x: e.elem1, barsSpace: barsSpace, barRods: [
        BarChartRodData(
          fromY: 0,
          toY: 0.0 + e.elem2,
          color: Colors.blue,
          width: 10,
        ),
      ])).toList();

    // BarChart bC = BarChart(BarChartData(
    //   maxY: 25,
    //   minY: 0,
    //     barGroups: barChartData,
    //     gridData: const FlGridData(show: false),
    //     groupsSpace: 40,
    //     barTouchData: BarTouchData(
    //       touchTooltipData: BarTouchTooltipData(
    //         tooltipBgColor: Colors.blueAccent,
    //       ),
    //     ),
    //     titlesData: const FlTitlesData(show: false),
    //     borderData: FlBorderData(show: true)));

  BarChart bC = BarChart(
              BarChartData(
                maxY: 42,
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: leftTitles,
                      interval: 2,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  //checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                   // color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: barChartData,
              ),
            );

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