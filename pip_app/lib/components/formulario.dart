import 'package:flutter/material.dart';
import 'package:pip_app/components/formulariodetalles.dart';

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

  @override
  void dispose() {
    _lugarOrigen.dispose();
    _lugarDestino.dispose();
    super.dispose();
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
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      decoration: const InputDecoration(
                        labelText: 'Escribe la localidad de origen',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                      ),
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
                      decoration: const InputDecoration(
                        labelText: 'Escribe la localidad de destino',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12,
                          color: Color.fromARGB(255, 196, 196, 196),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el destino';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 152.0),
                        child: SizedBox(
                          width: 118,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Navegar a la segunda pantalla con los datos de origen y destino
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FormularioDetalles(
                                      origen: _lugarOrigen.text,
                                      destino: _lugarDestino.text,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}