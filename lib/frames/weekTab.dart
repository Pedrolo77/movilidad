import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      List<int> conexionesSemana = await getConexionesSemana(selectedDate);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PopulationChartPage(
              conexionesSemana: conexionesSemana, selectedDate: selectedDate),
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
                  'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate.toLocal())}',
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

class PopulationChartPage extends StatefulWidget {
  final List<int> conexionesSemana;
  final DateTime selectedDate;
  PopulationChartPage(
      {required this.conexionesSemana, required this.selectedDate});

  @override
  State<PopulationChartPage> createState() => _PopulationChartPageState();
}

class _PopulationChartPageState extends State<PopulationChartPage> {
  @override
    List<String> dates = [];
  void initState() {
    for (int i = 6; i >= 0; i--) {
      DateTime date = widget.selectedDate.subtract(Duration(days: i));
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      dates.add(formattedDate);
    }
    super.initState();
  }

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
            child: showPopulationChart(widget.conexionesSemana),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < widget.conexionesSemana.length; i++)
                  Container(
                    width: 80,
                    child: Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          color: _getColor(i),
                        ),
                        SizedBox(height: 8),
                        Text(
                          dates[i],
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${widget.conexionesSemana[i]}',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<int>> getConexionesSemana(selectedDate) async {
    if (dates.isNotEmpty) {
      dates.clear(); // Borrar los valores existentes en la lista
    }

    DB database = DB();
    return await database.getConexionesSemana(selectedDate);
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.yellow;
      case 5:
        return Colors.red;
      case 6:
        return Colors.teal;
      default:
        return Colors.black;
    }
  }

  Widget showPopulationChart(List<int> conexionesSemana) {
    List<PieChartSectionData> pieChartData = [
      for (int i = 0; i < conexionesSemana.length; i++)
        PieChartSectionData(
          value: conexionesSemana[i].toDouble(),
          title: '${conexionesSemana[i]}',
          color: _getColor(i),
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Population Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Population Chart'),
        ),
        body: WeekTab(),
      ),
    );
  }
}
