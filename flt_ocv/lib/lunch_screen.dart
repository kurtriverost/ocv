import 'package:flutter/material.dart';

class LunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcaje de Almuerzo'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Mostrar el diálogo de confirmación
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmación'),
                  content: const Text('¿Desea confirmar su marca?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Cierra el cuadro de diálogo al cancelar
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Realizar acción de marcaje
                        Navigator.of(context).pop(); // Cierra el diálogo
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
            backgroundColor: Colors.blue,
          ),
          child: const Text('Realizar Marca de Almuerzo'),
        ),
      ),
    );
  }
}
