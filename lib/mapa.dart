import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movilidad/db.dart';
import 'package:movilidad/parada.dart';

class Mapa extends StatefulWidget {
  @override
  _Mapa createState() => _Mapa();
  
}
class _Mapa extends State<Mapa> {

  DB database = DB();
  List<Marker> M = List.empty(growable: true);
  List<Parada> P = List.empty(growable: true);

loadParadas() async{
  P = await database.getAllParadas();


  M = P.map((e) => Marker(
                width: 50,
                  height: 50,
                  point: LatLng(e.L.lat, e.L.long),
                  child: Container(
                          child: Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.amber,
                          size: 40,
                        ),
                      )))).toList();
}

  @override
  void initState() {
    super.initState();

    loadParadas();
  } 

void goToPageG(){
  Navigator.pushNamed(context, '/grafica');
}

  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Análisis de la Movilidad Urbana"),
        actions: [ElevatedButton(onPressed: ()=>goToPageG(), child: Text("G"))],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                  mapController.center, mapController.zoom - 0.5);
              setState(() {});
            },
            child: Icon(Icons.zoom_in_map),
          ),
          SizedBox(height: 20.0),
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                  mapController.center, mapController.zoom + 0.5);
              setState(() {});
            },
            child: Icon(Icons.zoom_out_map),
          ),
        ],
      ),
      body: Container(
        child: FlutterMap(
          mapController: mapController,
          options:
              const MapOptions(initialCenter: LatLng(20.9616700, -76.9511100), initialZoom: 14.0, ),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayer(
              markers: M)
          ],
        ),
      ),
    );
  }
}

class Localizacion {
  final double latitud;
  final double longitud;
  final String nombre;

  Localizacion(this.latitud, this.longitud, this.nombre);
} //AQUI CREAS UN OBJ LOCALIZACION

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
  List<Localizacion> localizaciones = [
    Localizacion(10.0, -70.0, "Localizacion 1"),
    Localizacion(12.0, -72.0, "Localizacion 2"),
    Localizacion(9.5, -71.5, "Localizacion 3"),
    Localizacion(11.0, -69.0, "Localizacion 4"),
    Localizacion(10.5, -71.0, "Localizacion 5"),
  ]; //EJEMPLO DE UNA LISTA CREADA

  if (!estaEnRango(latitud, longitud, latitudMaxima, longitudMaxima,
      latitudMinima, longitudMinima)) {
    return false;
  }

  for (var localizacion in localizaciones) {
    if (estaEnRango(localizacion.latitud, localizacion.longitud, latitudMaxima,
        longitudMaxima, latitudMinima, longitudMinima)) {
      return true; //COMPRUEBAS SI PERTENECE A ALGUNA DE LAS LOCALIZACIONES DE LAS PARADAS QUE SE ENCUENTRAN EN LA LISTA
    }
  }

  return false;
}
