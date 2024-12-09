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
    _loadMarkedData();
  }

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

  Future<void> _saveMarkedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMarked', isMarked);
    if (markedDate != null) {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await prefs.setString('markedDate', today);
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
                            setState(() {
                              isMarked = true;
                              markedDate = DateTime.now();
                            });
                            await _saveMarkedData();
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
                  return markedDate != null &&
                      DateFormat('yyyy-MM-dd').format(markedDate!) ==
                          DateFormat('yyyy-MM-dd').format(day);
                },
                onDaySelected: (selectedDay, focusedDay) {},
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
