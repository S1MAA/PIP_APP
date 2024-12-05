import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pip_app/screens/home.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nSeguimiento = TextEditingController();

  @override
  void dispose() {
    _nSeguimiento.dispose();
    super.dispose();
  }

  Future<void> _subirDatosYNavergar(BuildContext context) async {
    // Validar el formulario. Si no esta completo el campo, aparece el snackbar-----------------
    if (!_formKey.currentState!.validate()) {
      // Mostrar SnackBar si hay errores
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          duration: Duration(seconds: 3), //Duración del snackbar
          backgroundColor: Colors.red,
        ),
      );
      return; // Detener ejecución si hay errores
    }

    try {
      // Subir los datos a Firebase
      await FirebaseFirestore.instance.collection('Seguimiento').add({
        'seguimiento': _nSeguimiento.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Mostrar mensaje de éxito en snackbar -----------------
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos guardados exitosamente')),
      );

      // Navegar a la pantalla Home
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Seguimiento en línea',
                  style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingresa el número de seguimiento de tu pedido para brindarte información actualizada sobre su estado.',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nSeguimiento,
                  decoration: const InputDecoration(
                    labelText: 'Número de seguimiento',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 12,
                      color: Color.fromARGB(255, 196, 196, 196),
                    ),
                    errorStyle: TextStyle(
                      //Al no completar el campo, error de textfield rojo del textfield --------
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el número de seguimiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 330,
                    child: ElevatedButton(
                      onPressed: () => _subirDatosYNavergar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
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
        ),
      ),
    );
  }
}