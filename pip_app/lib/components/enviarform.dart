import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
  final TextEditingController _depto = TextEditingController();
  final TextEditingController _oficina = TextEditingController();
  final TextEditingController _regionOrigen = TextEditingController();
  final TextEditingController _comunaOrigen = TextEditingController();

  // Método para validar si todos los campos están completos
  bool _camposCompletos() {
    return _nombre.text.isNotEmpty &&
        _telefonoMovil.text.isNotEmpty &&
        _correoElectronico.text.isNotEmpty &&
        _direccionRemitente.text.isNotEmpty &&
        _depto.text.isNotEmpty &&
        _oficina.text.isNotEmpty &&
        _regionOrigen.text.isNotEmpty &&
        _comunaOrigen.text.isNotEmpty;
  }

  // Método para subir los datos a Firebase y navegar a otra pantalla
  Future<void> _subirDatosYNavegar(BuildContext context) async {
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
      await FirebaseFirestore.instance.collection('EnviarData').add({
        'nombre': _nombre.text, // Extraer texto del controlador
        'telefono': _telefonoMovil.text, // Extraer texto del controlador
        'correo': _correoElectronico.text,
        'direccion remitente': _direccionRemitente.text,
        'depto': _depto.text,
        'oficina': _oficina.text,
        'region': _regionOrigen.text,
        'comuna': _comunaOrigen.text,
        'timestamp': FieldValue.serverTimestamp(), // Fecha/hora del servidor
      });

      // Mostrar mensaje de éxito
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados exitosamente')),
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
    _depto.dispose();
    _oficina.dispose();
    _regionOrigen.dispose();
    _comunaOrigen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Datos de quién envía',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const Text(
              'Completa los datos de origen',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 14),
            const Text(
              'Nombre*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Teléfono móvil*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _telefonoMovil,
              decoration: const InputDecoration(
                labelText: '+56 9 5432 6789',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Correo electrónico*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _correoElectronico,
              decoration: const InputDecoration(
                labelText: 'sophia@gmail.com',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Dirección del remitente*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _direccionRemitente,
              decoration: const InputDecoration(
                labelText: 'Viña del cerro oriente 4486, Puente Alto',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Depto',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _depto,
              decoration: const InputDecoration(
                labelText: 'Ej A 12',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Oficina',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _oficina,
              decoration: const InputDecoration(
                labelText: 'Ej 123',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              '( * ) Campo obligatorio',
              style: TextStyle(fontSize: 12, fontFamily: 'Poppins-Regular'),
            ),

            const SizedBox(height: 30),
            const Text(
              'Dirección de origen',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const Text(
              'Selecciona la comuna y región de origen. Puedes usar cualquier Punto PIP! dentro de la región seleccionada para ir a dejar tu envío. Verás los más cercanos en el mapa.',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),


            const SizedBox(height: 12),
            const Text(
              'Región de origen',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _regionOrigen,
              decoration: const InputDecoration(
                labelText: 'Región Metropolitana de Santiago',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Comuna de origen*',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _comunaOrigen,
              decoration: const InputDecoration(
                labelText: 'Puente Alto',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                errorStyle: TextStyle(
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
              'Resultados de la búsqueda',
              style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
            ),
            const SizedBox(height: 8),
            const Text(
              '1 punto PIP!',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Regular'),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary, // Color de la línea
              thickness: 2.0,     // Grosor de la línea
            ),

            Container(
              width: double.infinity, // Ocupa el ancho completo
              height: 150.0, // Altura fija
              decoration: BoxDecoration(
                color: Colors.grey[300], // Color de fondo
                borderRadius: BorderRadius.circular(12.0), // Borde redondeado
              ),
              alignment: Alignment.center, // Centra el contenido
              child: const Text(
                'Imagen',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins-Bold',
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Punto PIP! Express',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Regular'),
            ),
            
            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: 330,
                child: FilledButton(
                  onPressed: () => _subirDatosYNavegar(context),
                  child: const Text('ENVIAR'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
