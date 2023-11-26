import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movilidad/models/Provincia.dart';
import 'package:movilidad/models/conexion.dart';
import 'package:movilidad/models/loc.dart';
import 'package:movilidad/models/parada.dart';
import 'package:movilidad/models/tuple.dart';
import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart';

class DB{

PostgreSQLConnection ?connection;


Future<void> connect() async {
  connection = PostgreSQLConnection(
    'localhost',
    5432,
    'gps',
    username: 'postgres',
    password: '123',
    timeoutInSeconds: 200,
  );

  await connection!.open();
}

 Future<List<Parada>> getAllParadas() async {
  await connect();
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.paradas join public.provincia on public.paradas.id_provincia = public.provincia.id_provincia');
  List<Parada> P= List.empty(growable: true);
 
 for (final row in results) {
    P.add(Parada(row[0],Loc(row[1], row[2]), row[3], row[4], row[6]));
  }

  await connection!.close();
  return P;
 }

 Future<List<Parada>> getParadasProvincia(int id) async {
  await connect();
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.paradas join public.provincia on public.paradas.id_provincia = public.provincia.id_provincia where public.provincia.id_provincia = $id');
  List<Parada> P= List.empty(growable: true);
 
 for (final row in results) {
    P.add(Parada(row[0],Loc(row[1], row[2]), row[3], row[4], row[6]));
  }

  await connection!.close();
  return P;
 }

Future<int> getConexionParada(int id, DateTime fechaD, String timeStart, String timeEnd) async {
  await connect();
  String fecha = "" + fechaD.day.toString() + '-' + fechaD.month.toString() + '-' + fechaD.year.toString();

  // Formatear la hora de inicio y fin del intervalo
  DateFormat formatoHora = DateFormat('HH:mm:ss');
  String horaInicio = "$timeStart:00";
  String horaFin = "$timeEnd:00";
  
//   List<List<dynamic>> results = await connection!.query("""
// SELECT count(*) FROM public.conexiones_parada join public.conexion
//  on public.conexiones_parada.id_conexion = public.conexion.id_conexion 
//  where public.conexiones_parada.id_parada = $id and public.conexion.fecha = '$fecha' a
//  nd public.conexion.hora >= '$horaInicio' and public.conexion.hora < '$horaFin'""");
  List<List<dynamic>> results = await connection!.query("""
  SELECT count(*) FROM public.conexiones_parada join public.conexion on 
  public.conexiones_parada.id_conexion = public.conexion.id_conexion where 
  public.conexiones_parada.id_parada = $id and public.conexion.fecha = '$fecha' 
  and public.conexion.hora between '$horaInicio' and '$horaFin';
  """);
  print(results.iterator);
  
  int cant = 0;
  for (final row in results) {
    cant = row[0];
  }

  await connection!.close();
  return cant;
}

Future<int> getConexionParadaFecha(int id, DateTime fechaD) async {
  await connect();
  String fecha = "" + fechaD.day.toString() + '-' + fechaD.month.toString() + '-' + fechaD.year.toString();

  List<List<dynamic>> results = await connection!.query("""SELECT count(*) FROM public.conexiones_parada join 
  public.conexion on public.conexiones_parada.id_conexion = public.conexion.id_conexion 
  where public.conexiones_parada.id_parada = $id and public.conexion.fecha = '$fecha'""");
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }

  await connection!.close();
  return cant;
 }


Future<List<int>> getConexionesSemana(DateTime fechaD) async {
  await connect();
  List<int> L = List.empty(growable: true);
String fecha = "" + fechaD.day.toString() + '-' + fechaD.month.toString() + '-' + fechaD.year.toString();
  for(int i = 0; i < 7;i++){
  List<List<dynamic>> results = await connection!.query("SELECT * FROM public.conexion where public.conexion.fecha = '$fecha'");
  int cant = 0;
 for (final row in results) {
    cant++;
  }  
  L.add(cant);
  fechaD = fechaD.subtract(const Duration(days: 1));
  fecha = "" + fechaD.day.toString() + '-' + fechaD.month.toString() + '-' + fechaD.year.toString();
  }

  await connection!.close();
  return L.reversed.toList();
 }

 Future<List<Tuple<int,int>>> getConexionesMes(DateTime selectedDate) async {
  await connect();
  List<Tuple<int,int>> L = List.empty(growable: true);

int cantdias = 0;
  if(selectedDate.month == 2){
    cantdias = 28;
  }
  else if (selectedDate.month == 4 || selectedDate.month == 6 || selectedDate.month == 9 || selectedDate.month == 11){
    cantdias = 30;
  }else{
    cantdias = 31;
  }

  DateTime newdate = selectedDate.copyWith(day: 1);

  String fecha = "" + newdate.day.toString() + '-' + newdate.month.toString() + '-' + newdate.year.toString();

  for(int i = 0; i <= cantdias-1;i++){
  List<List<dynamic>> results = await connection!.query("SELECT count(*) FROM public.conexion where public.conexion.fecha = '$fecha'");
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }  
  L.add(Tuple(i+1, cant));
  newdate = newdate.add(const Duration(days: 1));
  fecha = "" + newdate.day.toString() + '-' + newdate.month.toString() + '-' + newdate.year.toString();
  }

  await connection!.close();
  return L.toList();
 }


  Future<List<Tuple<int,int>>> getConexionesAno(DateTime selectedDate) async {
  await connect();
  List<Tuple<int,int>> L = List.empty(growable: true);


DateTime nd = selectedDate.copyWith(month: 1);

for(int i = 0; i <= 11; i++){

int cantdias = 0;
  if(nd.month == 2){
    cantdias = 28;
  }
  else if (nd.month == 4 || nd.month == 6 || nd.month == 9 || nd.month == 11){
    cantdias = 30;
  }else{
    cantdias = 31;
  }

  int conexionesMes = 0;

  DateTime newdate = nd.copyWith(day: 1);

  String fecha = "" + newdate.day.toString() + '-' + newdate.month.toString() + '-' + newdate.year.toString();

  for(int j = 0; j <= cantdias-1;j++){
  List<List<dynamic>> results = await connection!.query("SELECT count(*) FROM public.conexion where public.conexion.fecha = '$fecha'");
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }  
  conexionesMes+=cant;
  newdate = newdate.add(const Duration(days: 1));
  fecha = "" + newdate.day.toString() + '-' + newdate.month.toString() + '-' + newdate.year.toString();
  }

  L.add(Tuple(i+1, conexionesMes));
  nd = newdate.add(const Duration(days: 1));
}

  await connection!.close();
  return L.toList();
 }


 Future<List<Provincia>> getProvincias() async {
  await connect();

  List<Provincia> LP = List.empty(growable: true);

  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.provincia');
 for (final row in results) {
    LP.add(Provincia(row[0], row[1], Loc(row[2], row[3]), Loc(row[4], row[5]), Loc(row[6], row[7])));
  }

  await connection!.close();
  return LP;
 }


 void ordenarConexionesParada() async {
  await connect();

  List<Conexion> LC = List.empty(growable: true);
  List<Parada> LP = List.empty(growable: true);

  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.conexion');
 for (final row in results) {
    LC.add(Conexion(row[0], Loc(row[1], row[2]),row[3],row[4]));
  }


List<List<dynamic>> results2 = await connection!.query('SELECT * FROM public.paradas join public.provincia on public.paradas.id_provincia = public.provincia.id_provincia'); 
 for (final row in results2) {
    LP.add(Parada(row[0],Loc(row[1], row[2]), row[3], row[4], row[6]));
  }
//-0.0009, 0.0009
  // for(int i = 0; i < LC.length;i++){
  //   for(int j = 0; j < LP.length;j++){
  //     if(LC[i].L.lat >= LP[j].L.lat-0.0009 && LC[i].L.lat <= LP[j].L.lat+0.0009 && LC[i].L.long >= LP[j].L.long-0.0009 && LC[i].L.long >= LP[j].L.long-0.0009){
  //       await connection!.query('INSERT into public.conexiones_parada values(${LP[j].id}, ${LC[i].id})');
  //       break;
  //     }
  //   }
  // }

  await connection!.close();
 }

 Future<List<Marker>> getconexionesHora(DateTime date) async {
  
  await connect();

  List<Marker> L = List.empty(growable: true);

  String hora = "${date.hour}:${date.minute}:23";

  List<List<dynamic>> results = await connection!.query("SELECT * FROM public.conexion where public.conexion.hora = '$hora'");
  for (final row in results) {
    L.add(Marker(
                width: 10,
                  height: 10,
                  point: LatLng(row[1], row[2]),
                  child: const Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 20,
                  )));
  }

  await connection!.close();
  return L;
 }
  
}


