import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LunchScreen extends StatefulWidget {
  const LunchScreen({super.key});

  @override
  _LunchScreenState createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  bool isMarked = false;
  DateTime? markedDate;

  @override
  void initState() {
    super.initState();
    _loadMarkedData(); // Cargar datos al iniciar la pantalla
  }

  // Cargar datos de SharedPreferences
  Future<void> _loadMarkedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMarked = prefs.getBool('isMarked') ?? false;
      String? dateString = prefs.getString('markedDate');
      if (dateString != null) {
        markedDate = DateTime.parse(dateString);
      }
    });
  }

  // Guardar datos en SharedPreferences
  Future<void> _saveMarkedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMarked', isMarked);
    if (markedDate != null) {
      await prefs.setString('markedDate', markedDate!.toIso8601String());
    }
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
            const SizedBox(height: 20), // Espaciado entre el mensaje y el botón

            // Botón de marcar almuerzo
            ElevatedButton(
              onPressed: isMarked
                  ? () {
                // Mostrar SnackBar si ya marcó
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ya realizaste tu marca el día de hoy!'),
                  ),
                );
              }
                  : () {
                // Mostrar el cuadro de diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmación'),
                      content: const Text('¿Desea confirmar su marca?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar diálogo
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Confirmar la marca y registrar la fecha
                            setState(() {
                              isMarked = true;
                              markedDate = DateTime.now(); // Registrar la fecha actual
                            });
                            await _saveMarkedData(); // Guardar datos en SharedPreferences
                            Navigator.of(context).pop(); // Cerrar diálogo
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
            const SizedBox(height: 20), // Espaciado entre el botón y el calendario

            // Espacio flexible para empujar el calendario hacia abajo
            const Spacer(),

            // Calendario en la parte inferior
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                // Destacar el día si coincide con la marca
                return markedDate != null &&
                    DateFormat('yyyy-MM-dd').format(markedDate!) ==
                        DateFormat('yyyy-MM-dd').format(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Acciones al seleccionar un día (opcional)
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
          ],
        ),
      ),
    );
  }
}
