import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pip_app/components/appbar.dart'; // Acuérdate que modular estilos es el nombre MI PROYECTO
import 'package:pip_app/components/formulario.dart';

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
    const SearchScreen(),
    const BlogScreen(),
    const CallsScreen(),
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
        backgroundColor: const Color.fromARGB(255, 61, 0, 121), // Fondo de la NavigationBar
        indicatorColor: const Color.fromARGB(255, 157, 56, 170), // Color del indicador
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.local_shipping, color: Colors.white),
            label: 'Seguimiento',
          ),
          NavigationDestination(
            icon: Icon(Icons.send, color: Colors.white),
            label: 'Enviar',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate, color: Colors.white),
            label: 'Cotizar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context), // Usando la función de appbar.dart
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay registros disponibles.'));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color.fromARGB(255, 235, 235, 235), // Color del divisor
              thickness: 1, // Grosor del divisor
            ),
            itemBuilder: (context, index) {
              final usuario = usuarios[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  '${usuario['nombre']}',
                  style: const TextStyle(fontWeight: FontWeight.bold), // Título en negrita
                ),
                subtitle: Text('${usuario['telefono']}'), // Muestra el teléfono
              );
            },
          );
        },
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

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar'),
      ),
      body: const Center(
        child: Text('Enviar'),
      ),
    );
  }
}

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController origenController = TextEditingController();
    final TextEditingController destinoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 64.0,
        title: const Text(
          'Cotizar',
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 23,
            color: Colors.white, // El título será blanco
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white, // El ícono también será blanco
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
            children: [
              const Text(
                'Origen y destino',
                style: TextStyle(
                  fontSize: 19,
                  fontFamily: 'Poppins-Medium',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona la localidad desde y hacia donde envías',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Origen',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: origenController,
                decoration: const InputDecoration(
                  labelText: 'Escribe el origen',
                  border: OutlineInputBorder(),
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
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: destinoController,
                decoration: const InputDecoration(
                  labelText: 'Escribe el destino',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el destino';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (origenController.text.isNotEmpty &&
                        destinoController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos enviados correctamente')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, completa todos los campos')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('SIGUIENTE', 
                    style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium'
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: const Center(
        child: Text('Perfil'),
      ),
    );
  }
}
