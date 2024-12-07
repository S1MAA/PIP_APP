import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pip_app/screens/home.dart';

class CotizarForm extends StatefulWidget {
  const CotizarForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CotizarFormState createState() => _CotizarFormState();
}

class _CotizarFormState extends State<CotizarForm> {
  final TextEditingController _lugarOrigen = TextEditingController();
  final TextEditingController _lugarDestino = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _altoController = TextEditingController();

  // Método para validar si todos los campos están completos
  bool _camposCompletos() {
    return _lugarOrigen.text.isNotEmpty &&
        _lugarDestino.text.isNotEmpty &&
        _pesoController.text.isNotEmpty &&
        _largoController.text.isNotEmpty &&
        _anchoController.text.isNotEmpty &&
        _altoController.text.isNotEmpty;
  }

  // Método para subir los datos a Firebase y navegar a otra pantalla
  Future<void> _subirDatosYNavegar(BuildContext context) async {
    if (!_camposCompletos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return; // No continuar si los campos están incompletos
    }

    try {
      // Subir los datos a Firebase
      await FirebaseFirestore.instance.collection('CotizacionData').add({
        'origen': _lugarOrigen.text, // Extraer texto del controlador
        'destino': _lugarDestino.text, // Extraer texto del controlador
        'peso': _pesoController.text,
        'largo': _largoController.text,
        'ancho': _anchoController.text,
        'alto': _altoController.text,
        'timestamp': FieldValue.serverTimestamp(), // Fecha/hora del servidor
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados exitosamente')),
      );

      if (context.mounted) {
        Navigator.of(context).pop(
          MaterialPageRoute(
            builder: (context) => const Cotizar(),
          ),
        );
      }
    } catch (e) {
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
            Row(
              children: [
                Expanded(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Origen y destino',
                          style: TextStyle(
                              fontSize: 19, fontFamily: 'Poppins-Medium'),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Selecciona la localidad desde y hacia donde envías',
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Regular'),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Origen',
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Regular'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lugarOrigen,
                          decoration: InputDecoration(
                            labelText: 'Escribe la localidad de origen',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, complete los campos faltantes';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Destino',
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'Poppins-Regular'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lugarDestino,
                          decoration: InputDecoration(
                            labelText: 'Escribe la localidad de destino',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, complete los campos faltantes';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('Paquete seleccionado');
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'lib/assets/images/paquetelarge.png',
                        width: 315,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Divider(
              color:
                  Theme.of(context).colorScheme.secondary, // Color de la línea
              thickness: 2.0, // Grosor de la línea
            ),
            const SizedBox(height: 30),
            const Text(
              'Detalles de envío',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const Text(
              'Complete los detalles de su envío',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 20),
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
                        decoration: InputDecoration(
                          labelText: 'Ej 10 (kg)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, complete los campos faltantes';
                          }
                          return null;
                        },
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
                        decoration: InputDecoration(
                          labelText: 'Ej 10 (cm)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, complete los campos faltantes';
                          }
                          return null;
                        },
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
                        decoration: InputDecoration(
                          labelText: 'Ej 10 (cm)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, complete los campos faltantes';
                          }
                          return null;
                        },
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
                        decoration: InputDecoration(
                          labelText: 'Ej 10 (cm)',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, complete los campos faltantes';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 330,
                child: FilledButton(
                  onPressed: () => _subirDatosYNavegar(context),
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