import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pip_app/screens/home.dart';
import 'package:flutter/foundation.dart';


class FormularioDetalles extends StatefulWidget {
  final String origen; // Recibe el origen de la primera pantalla
  final String destino; // Recibe el destino de la primera pantalla

  const FormularioDetalles({
    super.key,
    required this.origen,
    required this.destino,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FormularioDetallesState createState() => _FormularioDetallesState();
}

class _FormularioDetallesState extends State<FormularioDetalles> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _altoController = TextEditingController();

  // Método para validar si todos los campos están completos
  bool _camposCompletos() {
    return _pesoController.text.isNotEmpty &&
        _largoController.text.isNotEmpty &&
        _anchoController.text.isNotEmpty &&
        _altoController.text.isNotEmpty;
  }

  // Método para subir los datos a Firebase y navegar a Cotizar
  Future<void> _subirDatosYNavergar(BuildContext context) async {
    if (!_camposCompletos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // No continuar si los campos están incompletos
    }

    try {
      // Subir los datos a Firebase
      await FirebaseFirestore.instance.collection('Cotizaciones').add({
        'origen': widget.origen, // Origen recibido de la primera pantalla
        'destino': widget.destino, // Destino recibido de la primera pantalla
        'peso': _pesoController.text,
        'largo': _largoController.text,
        'ancho': _anchoController.text,
        'alto': _altoController.text,
        'timestamp': FieldValue.serverTimestamp(), // Fecha/hora del servidor
      });

      // Mostrar mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados exitosamente')),
      );

      // Navegar a la pantalla Cotizar
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Cotizar(), // Ajusta según tu flujo
          ),
        );
      }
    } catch (e) {
      // Manejo de errores
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar los datos')),
      );
    }
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _largoController.dispose();
    _anchoController.dispose();
    _altoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 64.0,
        title: const Text(
          'Cotizar',
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador del progreso
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color.fromARGB(255, 61, 0, 121),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Color.fromARGB(255, 61, 0, 121),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Destino",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Medium',
                        color: Color.fromARGB(255, 61, 0, 121),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Color.fromARGB(255, 61, 0, 121),
                    height: 16,
                  ),
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color.fromARGB(255, 196, 196, 196),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Detalles",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Medium',
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Divider(
                    thickness: 2,
                    color: Color.fromARGB(255, 196, 196, 196),
                    height: 16,
                  ),
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color.fromARGB(255, 196, 196, 196),
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Cotización",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-Medium',
                        color: Color.fromARGB(255, 196, 196, 196),
                      ),
                    ),
                  ],
                ),
              ],
            ),



            // Encabezado
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Acción para el botón de paquete
                        if (kDebugMode) {
                          print('Paquete seleccionado');
                        }
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                18), // Esquinas redondeadas
                            child: Image.asset(
                              'lib/assets/images/paquete.png', // Ruta de tu imagen de paquete
                              height: 110,
                              width: 110,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 60),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Acción para el botón de documento
                        if (kDebugMode) {
                          print('Documento seleccionado');
                        }
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                18), // Esquinas redondeadas
                            child: Image.asset(
                              'lib/assets/images/doc.png', // Ruta de tu imagen de documento
                              height: 110,
                              width: 110,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),


            const Text(
              'Detalles de envío',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const Text(
              'Complete los detalles de su envío',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 20),

            // Campos de texto
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Peso',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Poppins-Regular'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _pesoController,
                        decoration: const InputDecoration(
                          labelText: 'Ingrese peso (kg)',
                          hintText: 'Ej: 2.5',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Largo',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Poppins-Regular'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _largoController,
                        decoration: const InputDecoration(
                          labelText: 'Ingrese largo (cm)',
                          hintText: 'Ej: 30',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ancho',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Poppins-Regular'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _anchoController,
                        decoration: const InputDecoration(
                          labelText: 'Ingrese ancho (cm)',
                          hintText: 'Ej: 10',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alto',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Poppins-Regular'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _altoController,
                        decoration: const InputDecoration(
                          labelText: 'Ingrese alto (cm)',
                          hintText: 'Ej: 15',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Botón para subir los datos
            Center(
              child: SizedBox(
                width: 330,
                child: ElevatedButton(
                  onPressed: () => _subirDatosYNavergar(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'GENERAR COTIZACIÓN',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-Medium',
                    ),
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