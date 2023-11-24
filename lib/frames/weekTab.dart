
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

      List<int> conexionesSemana = await getConexionesSemana(selectedDate);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PopulationChartPage(conexionesSemana: conexionesSemana),
        ),
      );
    }
  }

  Future<List<int>> getConexionesSemana(selectedDate) async {
    DB database = DB();
    return await database.getConexionesSemana(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
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
      ),
    );
  }
}

class PopulationChartPage extends StatelessWidget {
  final List<int> conexionesSemana;

  PopulationChartPage({required this.conexionesSemana});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de población'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: showPopulationChart(conexionesSemana),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text('Mon (${conexionesSemana[0]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text('Tue (${conexionesSemana[1]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text('Wed (${conexionesSemana[2]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.purple,
                ),
                SizedBox(width: 8),
                Text('Thu (${conexionesSemana[3]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.yellow,
                ),
                SizedBox(width: 8),
                Text('Fri (${conexionesSemana[4]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text('Sat (${conexionesSemana[5]})'),
                SizedBox(width: 16),
                Container(
                  width: 16,


height: 16,
                  color: Colors.teal,
                ),
                SizedBox(width: 8),
                Text('Sun (${conexionesSemana[6]})'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showPopulationChart(List<int> conexionesSemana) {
    List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        value: conexionesSemana[0].toDouble(),
        title: 'Mon',
        color: Colors.blue,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[1].toDouble(),
        title: 'Tue',
        color: Colors.green,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[2].toDouble(),
        title: 'Wed',
        color: Colors.orange,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[3].toDouble(),
        title: 'Thu',
        color: Colors.purple,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[4].toDouble(),
        title: 'Fri',
        color: Colors.yellow,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[5].toDouble(),
        title: 'Sat',
        color: Colors.red,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: conexionesSemana[6].toDouble(),
        title: 'Sun',
        color: Colors.teal,
        radius: 200,
        titleStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    PieChart PC = PieChart(
      PieChartData(
        sections: pieChartData,
        centerSpaceRadius: 0,
        sectionsSpace: 0,
        startDegreeOffset: -90,
        borderData: FlBorderData(show: false),
       
      ),
    );

    return PC;
  }
}