import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';


Future<int> getConexionesParadaFecha(int id, fecha) async{
  DB database = DB();
  return await database.getConexionParadaFecha(id, fecha);
}

Widget ParadaConstructor(snapshot, context, fecha){
  return ListView.builder(
    itemCount: snapshot.data!.length,
    itemBuilder: (BuildContext context, r) {
      return ListTile(title: Column(children: [Text(snapshot!.data[r].nombre), fecha],),subtitle: Text(getConexionesParadaFecha(snapshot!.data[r].id_provincia as int, fecha) as String),);
    },
  );
}