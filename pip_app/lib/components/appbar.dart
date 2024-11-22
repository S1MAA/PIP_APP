import 'package:flutter/material.dart';

// Definir la función buildAppBar
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    toolbarHeight: 64.0,
    title: const Text(
      'Whatsapp',
      style: TextStyle(
        fontFamily: 'Poppins-Regular',
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}
