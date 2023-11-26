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
            content: SizedBox(
              height: 500,
              width: 500,
              child: showPopulationChart(conexiones),
            ),
          );
        }));
  }

  Widget showPopulationChart(List<Tuple<int,int>> conexiones) {
    const barsSpace = 20.0 * 500 / 400;
    const barsWidth = 8.0 * 500 / 400;

    Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = 'E';
        break;
      case 2:
        text = 'F';
        break;
      case 3:
        text = 'M';
        break;
      case 4:
        text = 'A';
        break;
        case 5:
        text = 'M';
        break;
        case 6:
        text = 'J';
        break;
        case 7:
        text = 'J';
        break;
        case 8:
        text = 'A';
        break;
        case 9:
        text = 'S';
        break;
        case 10:
        text = 'O';
        break;
        case 11:
        text = 'N';
        break;
        case 12:
        text = 'D';
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
                maxY: 400,
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
                      interval: 100,
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