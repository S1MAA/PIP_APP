// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pip_app/components/appbar.dart'; // Acuérdate que modular estilos es el nombre MI PROYECTO
import 'package:pip_app/components/enviarform.dart';
import 'package:pip_app/components/formulario.dart';
import 'package:pip_app/components/cotizarform.dart';

// HOLA PROFE EL PROBLEMA ES QUE LA NAVIGATIONBAR NO SE VE, Y CUANDO SE HACE EL FORMULARIO EN ENVIAR CUANDO SE PONE SIGUIENTE NO SE VE LA NAVIGATION BAR

class Mantenedor extends StatefulWidget {
  const Mantenedor({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MantenedorState createState() => _MantenedorState();
}

class _MantenedorState extends State<Mantenedor> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
  const HomeScreen(),
  const Enviar(),
  const Cotizar(),
  const Perfil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping),
            label: 'Seguimiento',
          ),
          NavigationDestination(
            icon: Icon(Icons.near_me),
            label: 'Enviar',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Cotizar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}



//-----PANTALLA SEGUIMIENTO---------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      // Usando la función de appbar.dart
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Título agregado
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Actividad reciente',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontSize: 19,
              ),
            ),
          ),
          // Lista de tarjetas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Seguimiento')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No hay registros disponibles.'),
                  );
                }

                final seguimientos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: seguimientos.length,
                  itemBuilder: (context, index) {
                    final seguimiento =
                        seguimientos[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Imagen del paquete
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'lib/assets/images/paquete.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Información del paquete
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seguimiento['seguimiento'] ??
                                            'Sin seguimiento',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            'Estado:',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins-Regular',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Entregado', // Cambia por datos dinámicos si es necesario
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Fecha estimada: Día mes año', // Cambia por datos dinámicos
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9, // Ajusta la altura si deseas menos del 100%
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FormularioScreen(),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el modal
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

//----------------PANTALLA ENVIAR----------------
class Enviar extends StatelessWidget {
  const Enviar({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contenedor para los textos
                const Expanded(
                  flex: 2, // Ajusta el tamaño relativo
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haz tu envío',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins-Medium',
                        ),
                      ),
                      SizedBox(height: 8), // Espaciado entre los textos
                      Text(
                        'Realiza tus envíos individuales y masivos en simples pasos',
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1, // Ajusta el tamaño relativo
                  child: Image.asset(
                    'lib/assets/images/logo_pip.png',
                    width: 100, // Ajusta según necesidad
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32), // Espaciado entre la imagen y el botón

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnviarForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 113,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'NUEVO ENVÍO',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Tus envíos',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 24),

            //==================AQUÍ PARTE LA CARD=======================

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        'EnviarData') // Cambiado a la colección EnviarData
                    .orderBy('timestamp',
                        descending: true) // Ordenar por timestamp
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final envios = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: envios.length,
                    itemBuilder: (context, index) {
                      final envioDoc = envios[index];
                      final envio = envioDoc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Imagen
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Texto en el centro
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nombre: ${envio['nombre']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.bold,),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dirección: ${envio['direccion remitente']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Región: ${envio['region']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Comuna: ${envio['comuna']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                  ],
                                ),
                              ),
                              // Botones de eliminar y editar
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Eliminar envío',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium')),
                                            content: const Text(
                                                '¿Estás seguro de que deseas eliminar este envío? Esta acción no se puede deshacer.',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular')),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancelar',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Eliminar',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () async {
                                                  try {
                                                    // Eliminar envío de Firebase
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'EnviarData')
                                                        .doc(envioDoc.id)
                                                        .delete();
                                                    print('Envío eliminado');
                                                  } catch (e) {
                                                    print(
                                                        'Error al eliminar: $e');
                                                  } finally {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el diálogo
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // Aquí se crea el diálogo para editar
                                          TextEditingController
                                              nombreController =
                                              TextEditingController(
                                                  text: envio['nombre']);
                                          TextEditingController
                                              telefonoController =
                                              TextEditingController(
                                                  text: envio['telefono']);
                                          TextEditingController
                                              correoController =
                                              TextEditingController(
                                                  text: envio['correo']);
                                          TextEditingController
                                              direccionController =
                                              TextEditingController(
                                                  text: envio[
                                                      'direccion remitente']);
                                          TextEditingController
                                              regionController =
                                              TextEditingController(
                                                  text: envio['region']);
                                          TextEditingController
                                              comunaController =
                                              TextEditingController(
                                                  text: envio['comuna']);

                                          return AlertDialog(
                                            title: const Text('Editar envío',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium')),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        nombreController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Nombre',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        telefonoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Teléfono',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        correoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Correo',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        direccionController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Dirección remitente',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        regionController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Región',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        comunaController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Comuna',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancelar',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Guardar',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () async {
                                                  try {
                                                    // Actualizar envío en Firebase
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'EnviarData')
                                                        .doc(envioDoc.id)
                                                        .update({
                                                      'nombre':
                                                          nombreController.text,
                                                      'telefono':
                                                          telefonoController
                                                              .text,
                                                      'correo':
                                                          correoController.text,
                                                      'direccion remitente':
                                                          direccionController
                                                              .text,
                                                      'region':
                                                          regionController.text,
                                                      'comuna':
                                                          comunaController.text,
                                                    });

                                                    print('Envío actualizado');
                                                  } catch (e) {
                                                    print(
                                                        'Error al actualizar: $e');
                                                  } finally {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el diálogo
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//----------------PANTALLA COTIZAR----------------
class Cotizar extends StatelessWidget {
  const Cotizar({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Haz una cotización',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Genera tus nuevas cotizaciones en simples pasos',
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 28), //espacio entre texto y boton
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CotizarForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 113,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                '+ COTIZACIÓN',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tus cotizaciones',
              style: TextStyle(fontSize: 19, fontFamily: 'Poppins-Medium'),
            ),
            const SizedBox(height: 8),
            //Respuesta formulario cotizaciones
            // StreamBuilder para mostrar las cotizaciones en tiempo real
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        'CotizacionData') // Tu colección de cotizaciones
                    .orderBy('timestamp',
                        descending: true) // Ordenar por tiempo
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final cotizaciones = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: cotizaciones.length,
                    itemBuilder: (context, index) {
                      final cotizacionDoc = cotizaciones[index];
                      final cotizacion =
                          cotizacionDoc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Imagen
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.local_shipping,
                                  color: Colors.orange,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Texto en el centro
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Valor cotización \$7.990',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Localidad origen: ${cotizacion['origen']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Localidad destino: ${cotizacion['destino']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Dimensiones: ${cotizacion['largo']} x ${cotizacion['ancho']} x ${cotizacion['alto']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Peso: ${cotizacion['peso']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                  ],
                                ),
                              ),
                              // Botones de eliminar y editar
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Eliminar cotización',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium')),
                                            content: const Text(
                                                '¿Estás seguro de que deseas eliminar esta cotización? Esta acción no se puede deshacer.',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular')),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancelar',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Eliminar',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () async {
                                                  try {
                                                    // Eliminar cotización de Firebase
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'CotizacionData')
                                                        .doc(cotizacionDoc.id)
                                                        .delete();

                                                    print(
                                                        'Cotización eliminada');
                                                  } catch (e) {
                                                    print(
                                                        'Error al eliminar: $e');
                                                  } finally {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el diálogo
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // Aquí se crea el diálogo para editar
                                          TextEditingController
                                              origenController =
                                              TextEditingController(
                                                  text: cotizacion['origen']);
                                          TextEditingController
                                              destinoController =
                                              TextEditingController(
                                                  text: cotizacion['destino']);
                                          TextEditingController
                                              largoController =
                                              TextEditingController(
                                                  text: cotizacion['largo']);
                                          TextEditingController
                                              anchoController =
                                              TextEditingController(
                                                  text: cotizacion['ancho']);
                                          TextEditingController altoController =
                                              TextEditingController(
                                                  text: cotizacion['alto']);
                                          TextEditingController pesoController =
                                              TextEditingController(
                                                  text: cotizacion['peso']);

                                          return AlertDialog(
                                            title: const Text(
                                                'Editar cotización',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Medium')),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        origenController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Localidad origen',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller:
                                                        destinoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Localidad destino',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller: largoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Largo',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller: anchoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Ancho',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller: altoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Alto',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller: pesoController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Peso',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize:
                                                            14, // Tamaño de fuente del label
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize:
                                                          14, // Tamaño de fuente del texto ingresado
                                                      color: Colors
                                                          .black, // Color del texto ingresado
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancelar',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Guardar',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontFamily:
                                                            'Poppins-Regular')),
                                                onPressed: () async {
                                                  try {
                                                    // Actualizar cotización en Firebase
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'CotizacionData')
                                                        .doc(cotizacionDoc.id)
                                                        .update({
                                                      'origen':
                                                          origenController.text,
                                                      'destino':
                                                          destinoController
                                                              .text,
                                                      'largo':
                                                          largoController.text,
                                                      'ancho':
                                                          anchoController.text,
                                                      'alto':
                                                          altoController.text,
                                                      'peso':
                                                          pesoController.text,
                                                    });

                                                    print(
                                                        'Cotización actualizada');
                                                  } catch (e) {
                                                    print(
                                                        'Error al actualizar: $e');
                                                  } finally {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context)
                                                        .pop(); // Cierra el diálogo
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//----------------PANTALLA PERFIL----------------
class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 64.0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(65.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 90,
              backgroundImage: const AssetImage(
                  'lib/assets/images/avatar.jpg'), // Reemplaza con la ruta de tu imagen
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 20),

            // Nombre de usuario
            const Text(
              'Sophia Castillo Leyton',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Correo electrónico
            const Text(
              'correo@gmail.com',
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Botón de editar perfil
            ElevatedButton(
              onPressed: () {
                // Acción para editar perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditarPerfil(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Editar perfil',
                style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//----------------PANTALLA EDITAR PERFIL----------------
class EditarPerfil extends StatelessWidget {
  const EditarPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 64.0,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 23,
          ),
        ),
      ),
      body: const Center(
        child: Text('Pantalla de edición :)'),
      ),
    );
  }
}