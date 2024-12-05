import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    toolbarHeight: 270, // Ajusta la altura según el contenido
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saludo y avatar
        const Row(
          children: [
            CircleAvatar(
              radius: 16, // Tamaño del avatar
              backgroundColor: Colors.white, // Fondo del avatar
              backgroundImage: AssetImage(
                  'lib/assets/images/avatar.jpg'), // Ruta de la imagen
            ),
            SizedBox(width: 16), // Espaciado entre el avatar y el texto
            Text(
              'Hola Sophia', // Cambié el texto para que sea más dinámico
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 23,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Título de seguimiento
        const Text(
          'Seguimiento en línea',
          style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa el número de seguimiento de tu pedido',
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 18,
            color: Colors.white,
          ),
          maxLines: 2, // Permite un máximo de 2 líneas
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 24),
        // Barra de búsqueda y botón de cámara

        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  color: Colors.black, // Cambia el color del texto ingresado
                  fontSize: 16, // Tamaño de fuente del texto
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Colors.white, // Fondo blanco para el campo de texto
                  hintText: 'Número de seguimiento',
                  hintStyle: TextStyle(
                    color: Colors.grey[400], // Cambia el color del hint text
                    fontSize: 14,
                    fontFamily:
                        'Poppins-Regular', // Tamaño de fuente del hint text
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {
                // Acción para el botón de cámara
              },
            ),
          ],
        )
      ],
    ),
    /* actions: [
      // Ícono de notificaciones con indicador
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Acción de notificaciones
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    ],*/
  );
}