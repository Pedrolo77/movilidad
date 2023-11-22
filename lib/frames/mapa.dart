import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/models/Provincia.dart';
import 'package:movilidad/models/loc.dart';
import 'package:movilidad/models/parada.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Mapa createState() => _Mapa();
  
}
class _Mapa extends State<Mapa> {

  DB database = DB();
  List<Marker> M = List.empty(growable: true);
  List<Parada> P = List.empty(growable: true);
  List<Provincia> provincias = List.empty(growable: true);
  Provincia principal = Provincia(0, "", Loc(0.0, 0.0), Loc(0.0, 0.0), Loc(0.0, 0.0));
  LatLng LATLONG = LatLng(0.0, 0.0);

loadParadas() async{

  provincias = await database.getProvincias();
    principal = provincias[0];

  P = await database.getParadasProvincia(principal.id);
  // ignore: await_only_futures
  M = await P.map((e) => Marker(
                width: 50,
                  height: 50,
                  point: LatLng(e.L.lat, e.L.long),
                  child: const Icon(
                  Icons.location_on,
                  color: Colors.amber,
                  size: 40,
                  ))).toList();
}

  @override
  void initState() {
    super.initState();

    loadParadas();
    setState(() {
      
    });
  } 

void goToPageG(){
  Navigator.pushNamed(context, '/grafica');
}

void escogerProvincia(){
   showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Container(
              height: 400,
              width: 400,
              child: 
              ListView(children: provincias.map((e) => ListTile(title: Text(e.nombre),onTap: () {
                    setState(() {
                      principal = e;
                      LATLONG = LatLng(principal.C.lat, principal.C.long);
                    });
                  },)).toList(),)
            ),
          );
        }));
}

  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de la Movilidad Urbana"),
        leading: Text(principal.nombre),
        actions: [
          ElevatedButton(onPressed: ()=>goToPageG(), child: const Text("G")),
          ElevatedButton(onPressed: ()=>escogerProvincia(), child: const Text("Provincia"))
          ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 0.5);
              setState(() {});
            },
            child: const Icon(Icons.zoom_in_map),
          ),
          const SizedBox(height: 20.0),
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom + 0.5);
              setState(() {});
            },
            child: const Icon(Icons.zoom_out_map),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options:
            MapOptions(initialCenter: LATLONG, initialZoom: 14.0, ),
        children: [
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
          MarkerLayer(
            markers: M)
        ],
      ),
    );
  }
}

bool estaEnRango(double latitud, double longitud, double latitudMaxima,
    double longitudMaxima, double latitudMinima, double longitudMinima) {
  return (latitud >= latitudMinima && latitud <= latitudMaxima) &&
      (longitud >= longitudMinima && longitud <= longitudMaxima);
} //ESTE METODO COMPRUEBA SI UNA LOCALIZACION ESPECIFICA SE ENCUENTRA DENTRO DE UN CLUSTER, EN ESTE CASO LOS CLUSTER PROVINCIA

bool estaEnAlgunaLocalizacion(
    double latitud,
    double longitud,
    double latitudMaxima,
    double longitudMaxima,
    double latitudMinima,
    double longitudMinima) {
  

  if (!estaEnRango(latitud, longitud, latitudMaxima, longitudMaxima,
      latitudMinima, longitudMinima)) {
    return false;
  }

  return false;
}
