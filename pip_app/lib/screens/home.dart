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
          // Título agregado
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Actividad reciente',
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 18,
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
      ),
      body: const Center(
        child: EnviarForm(),
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
            const SizedBox(height: 40),
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
                    .collection('CotizacionData') // Tu colección de cotizaciones
                    .orderBy('timestamp', descending: true) // Ordenar por tiempo
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
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 2,
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
                                          fontSize: 16, fontFamily: 'Poppins-Bold'),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Localidad origen: ${cotizacion['origen']}',
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Localidad destino: ${cotizacion['destino']}',
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Dimensiones: ${cotizacion['largo']} x ${cotizacion['ancho']} x ${cotizacion['alto']}',
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins-Regular'),
                                    ),
                                    Text(
                                      'Peso: ${cotizacion['peso']}',
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins-Regular'),
                                    ),
                                  ],
                                ),
                              ),
                              // Botón de eliminar
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar cotización'),
                                        content: const Text(
                                            '¿Estás seguro de que deseas eliminar esta cotización? Esta acción no se puede deshacer.'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Eliminar',
                                                style: TextStyle(color: Colors.red)),
                                            onPressed: () async {
                                              try {
                                                // Eliminar cotización de Firebase
                                                await FirebaseFirestore.instance
                                                    .collection('CotizacionData')
                                                    .doc(cotizacionDoc.id)
                                                    .delete();

                                                print('Cotización eliminada');
                                              } catch (e) {
                                                print('Error al eliminar: $e');
                                              } finally {
                                                Navigator.of(context).pop(); // Cierra el diálogo
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
            icon: const Icon(
              Icons.more_vert,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Perfil'),
      ),
    );
  }
}