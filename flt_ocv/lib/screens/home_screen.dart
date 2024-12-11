import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lunch_screen.dart';
import 'login_screen.dart'; // Importa tu pantalla de login aquí

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMarked = false; // Estado de marcaje
  String? markedDate; // Fecha del último marcaje

  @override
  void initState() {
    super.initState();
    _loadMarkedData(); // Cargar el estado inicial
  }

  // Cargar datos desde SharedPreferences
  Future<void> _loadMarkedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDate = prefs.getString('markedDate');
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('markedDate', today);

    setState(() {
      markedDate = storedDate;
      isMarked = (storedDate == today); // Verifica si la fecha almacenada es igual a hoy
    });
  }

  // Función para hacer logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos almacenados

    // Navegar a la pantalla de login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Elimina todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d \'de\' MMMM \'del\' yyyy', 'es').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calidad de Vida'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tarjeta de identificación personalizada
            InkWell(
              onTap: () {
                // Acción al hacer clic en la tarjeta de identificación
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.indigo[900]!,
                    width: 2,
                  ),
                ),
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://images6.fanpop.com/image/photos/34900000/Killua-killua-zoldyck-2011-34976867-1729-1495.png',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Kurt Riveros',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  '300',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Puntos',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tarjeta de marcaje de almuerzo
            InkWell(
              onTap: () {
                // Navegar a LunchScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LunchScreen(),
                  ),
                ).then((_) => _loadMarkedData()); // Actualizar estado al regresar
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Marcaje de Almuerzo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          Text(formattedDate),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMarked ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isMarked
                              ? 'Ya marcaste tu almuerzo'
                              : 'Pendiente de marcaje',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tarjeta de ganar puntos
            InkWell(
              onTap: () {
                // Acción al hacer clic en la tarjeta de ganar puntos
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sube las Escaleras y Gana Puntos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text('300 puntos disponibles'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Botón de logout
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
