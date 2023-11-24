
import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/models/Provincia.dart';
import 'package:movilidad/models/loc.dart';
import 'package:movilidad/models/parada.dart';

class DayTab extends StatefulWidget {
  List<Parada> Pi = List.empty(growable: true);
  DayTab({super.key, required P}) {
    Pi = P;
  }

  @override
  _DayTabState createState() => _DayTabState();
}

class _DayTabState extends State<DayTab> {
  DB database = DB();
  Provincia provincia = Provincia(1, "Las Tunas", Loc(20.73993, -77.838002),
      Loc(21.31422, -76.303427), Loc(20.9616700, -76.9511100));

  DateTime selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  List<Parada> filteredParadas = [];

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    provincia = Provincia(1, "Las Tunas", Loc(20.73993, -77.838002),
        Loc(21.31422, -76.303427), Loc(20.9616700, -76.9511100));
    filteredParadas = widget.Pi;
    super.initState();
  }

  Future<int> getConexionesParadaFecha(int id, fecha) async {
    DB database = DB();
    return await database.getConexionParadaFecha(id, fecha);
  }

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
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _filterParadas(String query) {
    setState(() {
      filteredParadas = widget.Pi
          .where((parada) =>
              parada.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Seleccionar fecha'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterParadas,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre de parada',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredParadas.length,
              itemBuilder: (BuildContext context, r) {
                return ListTile(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bus_alert),
                          SizedBox(width: 8),
                          Text(filteredParadas[r].nombre),
                        ],
                      ),
                    ],
                  ),
                  subtitle: FutureBuilder(
                    future: getConexionesParadaFecha(
                        filteredParadas[r].id, selectedDate),
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 8),
                            Text(snapshot.data.toString()),
                          ],
                        );
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectTime(context),
        child: Icon(Icons.access_time),
      ),
    );
  }
}