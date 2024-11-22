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
  final TextEditingController _lugarOrigen = TextEditingController();
  final TextEditingController _lugarDestino = TextEditingController();

//AQUÍ SE CONECTA CON LA BASE DE DATOS
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('origen').add({
          'origen': _lugarOrigen.text,      
        });

        await FirebaseFirestore.instance.collection('destino').add({
          'destino': _lugarDestino.text,      
        });

        _lugarOrigen.clear();
        _lugarDestino.clear();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados exitosamente')),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Recuérdame....ingleChildScrollView
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
                            backgroundColor: Colors.white,
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
                const SizedBox(height: 30),
                const Text(
                  'Origen y destino',
                  style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
                ),
                const Text(
                  'Selecciona la localidad desde y hacia donde envías',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Origen',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lugarOrigen,
                  decoration: const InputDecoration(labelText: 'Escribe la localidad de origen', 
                  labelStyle: TextStyle(fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el origen';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                const Text(
                  'Destino',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins-Regular'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lugarDestino,
                  decoration: const InputDecoration(labelText: 'Escribe la localidad de destino', 
                  labelStyle: TextStyle(fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color.fromARGB(255, 196, 196, 196))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el destino';
                    }
                    return null;
                  },
                ),
              
                const SizedBox(height: 20),
                Positioned(
                  bottom: 95, // Margen desde la parte inferior
                  left: 90,  // Margen desde la parte derecha
                  child: SizedBox(
                    width: 103, // Ancho del botón
                    child: ElevatedButton(
                      onPressed: () async {
                        // Ejecutar la función _submitForm
                        await _submitForm(context);
                        // Navegar a la nueva pantalla
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BlogScreen(), //PONER LA SIGUIENTE PANTALLA
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16), // Altura del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        'SIGUIENTE',
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
