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
  // ignore: library_private_types_in_public_api
  _DayTabState createState() => _DayTabState();
}

class _DayTabState extends State<DayTab> {
  DB database = DB();
  Provincia provincia = Provincia(1, "Las Tunas", Loc(20.73993, -77.838002),
      Loc(21.31422, -76.303427), Loc(20.9616700, -76.9511100));

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    provincia = Provincia(1, "Las Tunas", Loc(20.73993, -77.838002),
        Loc(21.31422, -76.303427), Loc(20.9616700, -76.9511100));
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [  ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Seleccionar fecha'),
        )],),
      body: ListView.builder(
        itemCount: widget.Pi.length,
        itemBuilder: (BuildContext context, r) {
          return ListTile(
            title: Column(
              children: [
                Text(widget.Pi[r].nombre),
              ],
            ),
            subtitle: FutureBuilder(
              future: getConexionesParadaFecha(widget.Pi[r].id, selectedDate),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else {
                  return Text("No data");
                }
              },
            ),
          );
        },
      ),
    );
    /*Text(
          'Fecha seleccionada: ${selectedDate.toLocal()}',
          style: const TextStyle(fontSize: 20),
        ),*/
  }
}
