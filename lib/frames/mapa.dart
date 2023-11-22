import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:movilidad/bd/db.dart';
import 'package:movilidad/frames/day_tab.dart';
import 'package:movilidad/frames/grafica_page.dart';
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
  LatLng LATLONG = LatLng(20.96167, -76.95111);

loadParadas() async{

  provincias = await database.getProvincias();
    principal = provincias[0];

  P = await database.getParadasProvincia(principal.id);
  // ignore: await_only_futures
  M = await P.map((e) => Marker(
                width: 10,
                  height: 10,
                  point: LatLng(e.L.lat, e.L.long),
                  child: const Icon(
                  Icons.bus_alert,
                  color: Colors.red,
                  size: 40,
                  ))).toList();

  database.ordenarConexionesParada();


  setState(() {
    
  });
}

  @override
  void initState() {
    super.initState();

    loadParadas();
  } 

void goToPageG(){
  Navigator.push(context, MaterialPageRoute(builder: (context) => GraficaPage(P: P),));
}

void escogerProvincia() {
  showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        content: Container(
          height: 400,
          width: 400,
          child: ListView(
            children: provincias
                .map(
                  (e) => ListTile(
                    title: Text(e.nombre),
                    onTap: () {
                      setState(() {
                        principal = e;
                        LATLONG = LatLng(principal.C.lat, principal.C.long);
                        loadParadas(); // Update map data
                      });
                      Navigator.pop(context); // Close dialog
                    },
                  ),
                )
                .toList(),
          ),
        ),
      );
    }),
  ).then((value) {
    // Update map center after dialog is closed
    mapController.move(LATLONG, mapController.zoom);
  });
}

void mostrarUltimaHora() async{
  M = await database.getconexionesHora(DateTime(2023, 11, 30,17,3,23));
  setState(() {
    mapController.move(LATLONG, mapController.zoom);
  });
}

  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de la Movilidad Urbana"),
        actions: [
          ElevatedButton(onPressed: ()=>goToPageG(), child: const Text("Estadisticas")),
          ElevatedButton(onPressed: ()=>escogerProvincia(), child: const Text("Seleccionar provincia")),
          ElevatedButton(onPressed: ()=>mostrarUltimaHora(), child: const Text("Mostrar Ultima Hora")),
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
            MapOptions(initialCenter: LATLONG, initialZoom: 14.0),
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