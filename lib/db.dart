import 'package:movilidad/loc.dart';
import 'package:movilidad/parada.dart';
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
  List<List<dynamic>> results = await connection!.query('SELECT * FROM public.paradas');
  List<Parada> P= List.empty(growable: true);
 
 for (final row in results) {
    P.add(Parada(Loc(row[1], row[2]), row[3], row[4] , row[0]));
  }

  await connection!.close();
  return P;
 }
  
}


