import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/models/Provincia.dart';
import 'package:movilidad/models/loc.dart';
import 'package:movilidad/models/parada.dart';
import 'package:movilidad/widgets/paradasConstructor.dart';

class DayTab extends StatefulWidget {
  const DayTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DayTabState createState() => _DayTabState();
}

class _DayTabState extends State<DayTab> {

  Provincia provincia = Provincia(1,"Las Tunas", Loc(20.73993,-77.838002),Loc(21.31422,-76.303427), Loc(20.9616700, -76.9511100));
  DateTime selectedDate = DateTime.now();

  List<Parada> lp = List.empty(growable: true);
  
  @override
  void initState() {
    super.initState();
     getparadas();
  }

  getparadas() async{
    DB database = DB();
      lp = await database.getParadasProvincia(provincia.id);
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
              ParadaConstructor(lp, context, selectedDate),
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