List<String> getFechasMes(DateTime selectedDate) {
  List<String> fechas = [];

  int cantdias = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

  for (int i = 1; i <= cantdias; i++) {
    DateTime fecha = DateTime(selectedDate.year, selectedDate.month, i);
    String fechaString = DateFormat('dd-MM-yyyy').format(fecha);
    fechas.add(fechaString);
  }

  return fechas;
}

void main() {
  print(getFechasMes(DateTime.now()));
}