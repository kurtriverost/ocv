import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LunchScreen extends StatefulWidget {
  const LunchScreen({super.key});

  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  Map<String, bool> marks = {}; // Mapa que almacena las marcas
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Fecha actual
  bool isMarked = false;

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  // Cargar las marcas desde SharedPreferences
  Future<void> _loadMarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? marksString = prefs.getString('marks');

    if (marksString != null) {
      // Deserializar el mapa
      final Map<String, dynamic> loadedMarks = json.decode(marksString);
      marks = loadedMarks.map((key, value) => MapEntry(key, value as bool));
    }

    // Asegurar que el mapa esté actualizado con los últimos 10 días
    _updateLast10Days();

    setState(() {
      isMarked = marks[today] ?? false;
    });
    print("hola amigue");
    print(marks);
  }

  // Actualizar el mapa para que contenga los últimos 10 días, ordenados cronológicamente
  void _updateLast10Days() {
    final DateTime now = DateTime.now();
    final List<String> last10Days = List.generate(
      10,
          (index) => DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: index))),
    ).reversed.toList();

    // Agregar días faltantes
    for (String day in last10Days) {
      if (!marks.containsKey(day)) {
        marks[day] = false; // Inicializar como `false` si el día no existe
      }
    }

    // Eliminar días fuera del rango de los últimos 10 días
    marks.removeWhere((key, value) => !last10Days.contains(key));

    // Ordenar el mapa cronológicamente
    marks = Map.fromEntries(
      marks.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)), // Ordenar por fecha (clave)
    );
  }

  // Guardar las marcas en SharedPreferences
  Future<void> _saveMarks() async {
    final prefs = await SharedPreferences.getInstance();

    // Serializar el mapa
    final String marksString = json.encode(marks);
    await prefs.setString('marks', marksString);
  }

  // Agregar una marca
  Future<void> _addMark() async {
    setState(() {
      // Marcar el día actual
      //marks[today] = true;
      isMarked = true;
      marks["2024-12-10"] = true;

      // Asegurarse de que el mapa mantenga los últimos 10 días
      _updateLast10Days();
    });

    await _saveMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcaje de Almuerzo'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mensaje superior
            const Text(
              '¿Vas a salir a almorzar hoy?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Botón de marcar almuerzo
            ElevatedButton(
              onPressed: isMarked
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ya realizaste tu marca el día de hoy!'),
                  ),
                );
              }
                  : () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmación'),
                      content: const Text('¿Desea confirmar su marca?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _addMark();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Marca registrada con éxito!'),
                              ),
                            );
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isMarked ? Colors.grey : Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                isMarked ? 'Ya marcaste tu almuerzo' : 'Realizar Marca de Almuerzo',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Calendario con un espacio proporcional
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  final dayString = DateFormat('yyyy-MM-dd').format(day);
                  return marks[dayString] ?? false; // Resaltar si el día está marcado
                },
                onDaySelected: (selectedDay, focusedDay) {
                  final dayString = DateFormat('yyyy-MM-dd').format(selectedDay);
                  final marked = marks[dayString] ?? false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(marked
                          ? 'El ${DateFormat('dd/MM/yyyy').format(selectedDay)} fue marcado.'
                          : 'El ${DateFormat('dd/MM/yyyy').format(selectedDay)} no fue marcado.'),
                    ),
                  );
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
