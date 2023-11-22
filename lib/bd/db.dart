import 'package:movilidad/models/Provincia.dart';
import 'package:movilidad/models/loc.dart';
import 'package:movilidad/models/parada.dart';
import 'package:movilidad/models/tuple.dart';
import 'package:postgres/postgres.dart';

class DB{

PostgreSQLConnection ?connection;


Future<void> connect() async {
  connection = PostgreSQLConnection(
    'localhost',
    5432,
    'gps',
    username: 'postgres',
    password: '123',
  );

  await connection!.open();
}

 Future<List<Parada>> getAllParadas() async {
  await connect();
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.paradas join public.provincia on public.paradas.id_provincia = public.provincia.id_provincia');
  List<Parada> P= List.empty(growable: true);
 
 for (final row in results) {
    P.add(Parada(row[0],Loc(row[1], row[2]), row[3], row[4], row[5]));
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

Future<int> getConexionParadaFecha(int id, fecha) async {
  await connect();
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.conexiones_parada join public.conexion where public.conexiones_parada.id_parada = $id and public.conexion.fecha = $fecha');
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }

  await connection!.close();
  return cant;
 }


Future<List<int>> getConexionesSemana(DateTime selectedDate) async {
  await connect();
  List<int> L = List.empty(growable: true);

  for(int i = 0; i < 7;i++){
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.conexion where public.conexion.fecha = $selectedDate');
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }  
  L.add(cant);
  selectedDate.subtract(const Duration(days: 1));
  }

  await connection!.close();
  return L.reversed.toList();
 }

 Future<List<Tuple<int,int>>> getConexionesMes(DateTime selectedDate) async {
  await connect();
  List<Tuple<int,int>> L = List.empty(growable: true);

int cantdias = 0;
  if(selectedDate.month == 1){
    cantdias = 28;
  }
  else if (selectedDate.month == 3 && selectedDate.month == 5 && selectedDate.month == 8 && selectedDate.month == 10){
    cantdias = 30;
  }else{
    cantdias = 31;
  }

  DateTime newdate = selectedDate.copyWith(day: 1);

  for(int i = 0; i < cantdias-1;i++){
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.conexion where public.conexion.fecha = $newdate');
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }  
  L.add(Tuple(i+1, cant));
  newdate.add(const Duration(days: 1));
  }

  await connection!.close();
  return L.reversed.toList();
 }


  Future<List<Tuple<int,int>>> getConexionesAno(DateTime selectedDate) async {
  await connect();
  List<Tuple<int,int>> L = List.empty(growable: true);


DateTime nd = selectedDate.copyWith(month: 1);

for(int i = 0; i < 11; i++){

int cantdias = 0;
  if(selectedDate.month == 1){
    cantdias = 28;
  }
  else if (selectedDate.month == 3 && selectedDate.month == 5 && selectedDate.month == 8 && selectedDate.month == 10){
    cantdias = 30;
  }else{
    cantdias = 31;
  }

  int conexionesMes = 0;

  DateTime newdate = nd.copyWith(day: 1);

  for(int j = 0; j < cantdias-1;j++){
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.conexion where public.conexion.fecha = $newdate');
  int cant = 0;
 for (final row in results) {
    cant = row[0];
  }  
  conexionesMes+=cant;
  newdate.add(const Duration(days: 1));
  }

  L.add(Tuple(i+1, conexionesMes));
  nd.add(const Duration(days: 1));
}

  await connection!.close();
  return L.reversed.toList();
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
  
}


