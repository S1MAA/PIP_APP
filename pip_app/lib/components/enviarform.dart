import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pip_app/screens/home.dart';

class EnviarForm extends StatefulWidget {
  const EnviarForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EnviarFormState createState() => _EnviarFormState();
}

class _EnviarFormState extends State<EnviarForm> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _telefonoMovil = TextEditingController();
  final TextEditingController _correoElectronico = TextEditingController();
  final TextEditingController _direccionRemitente = TextEditingController();
  final TextEditingController _regionOrigen = TextEditingController();
  final TextEditingController _comunaOrigen = TextEditingController();

  // Método para validar si todos los campos están completos
  bool _camposCompletos() {
    return _nombre.text.isNotEmpty &&
        _telefonoMovil.text.isNotEmpty &&
        _correoElectronico.text.isNotEmpty &&
        _direccionRemitente.text.isNotEmpty &&
        _regionOrigen.text.isNotEmpty &&
        _comunaOrigen.text.isNotEmpty;
  }

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
      await FirebaseFirestore.instance.collection('EnviarData').add({
        'nombre': _nombre.text, // Extraer texto del controlador
        'telefono': _telefonoMovil.text, // Extraer texto del controlador
        'correo': _correoElectronico.text,
        'direccion remitente': _direccionRemitente.text,
        'region': _regionOrigen.text,
        'comuna': _comunaOrigen.text,
        'timestamp': FieldValue.serverTimestamp(), // Fecha/hora del servidor
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados exitosamente')),
      );

      // Mostrar mensaje de éxito
      if (context.mounted) {
        Navigator.of(context).pop(
          MaterialPageRoute(
            builder: (context) => const Enviar(),
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
    _nombre.dispose();
    _telefonoMovil.dispose();
    _correoElectronico.dispose();
    _direccionRemitente.dispose();
    _regionOrigen.dispose();
    _comunaOrigen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 64.0,
        title: const Text(
          'Enviar',
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Datos de quién envía',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa los datos de origen',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nombre*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nombre,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
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
            const SizedBox(height: 20),
            const Text(
              'Teléfono móvil*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _telefonoMovil,
              decoration: InputDecoration(
                labelText: '9 5432 6789',
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
            const SizedBox(height: 20),
            const Text(
              'Correo electrónico*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _correoElectronico,
              decoration: InputDecoration(
                labelText: 'correo@gmail.com',
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
            const SizedBox(height: 20),
            const Text(
              'Dirección del remitente*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _direccionRemitente,
              decoration: InputDecoration(
                labelText: 'Cerro oriente 4486, Puente Alto',
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
            const SizedBox(height: 12),
            const Text(
              '( * ) Campo obligatorio',
            ),
            const SizedBox(height: 30),
            Divider(
              color:
                  Theme.of(context).colorScheme.secondary, // Color de la línea
              thickness: 2.0, // Grosor de la línea
            ),
            const SizedBox(height: 30),
            const Text(
              'Dirección de origen',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona la comuna y región de origen. Puedes usar cualquier Punto PIP! dentro de la región seleccionada para ir a dejar tu envío. Verás los más cercanos en el mapa.',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Región de origen*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _regionOrigen,
              decoration: InputDecoration(
                labelText: 'Metropolitana de Santiago',
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
            const SizedBox(height: 20),
            const Text(
              'Comuna de origen*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _comunaOrigen,
              decoration: InputDecoration(
                labelText: 'Puente Alto',
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
            const SizedBox(height: 12),
            const Text('( * ) Campo obligatorio'),
            const SizedBox(height: 24),
            const Text(
              'Resultados de la búsqueda',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            const Text(
              '1 punto PIP!',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, // Ocupa el ancho completo
              height: 150.0, // Altura fija
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 255, 240, 220), // Color de fondo
                borderRadius: BorderRadius.circular(12.0), // Borde redondeado
              ),
              alignment: Alignment.center, // Centra el contenido
              child: const Text(
                'Mapa',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
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
                    'ENVIAR',
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