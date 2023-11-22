import 'package:flutter/material.dart';
import 'package:movilidad/bd/db.dart';


Future<int> getConexionesParadaFecha(int id, fecha) async{
  DB database = DB();
  return await database.getConexionParadaFecha(id, fecha);
}

Widget ParadaConstructor(lp, context, fecha){
  return ListView.builder(
    itemCount: lp.length,
    itemBuilder: (BuildContext context, r) {
      return ListTile(title: Column(children: [Text(lp[r].nombre), fecha],),subtitle: Text(getConexionesParadaFecha(lp[r].id_provincia as int, fecha) as String),);
    },
  );
}