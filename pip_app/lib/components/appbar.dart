import 'package:flutter/material.dart';

// Definir la función buildAppBar
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    toolbarHeight: 240.0,
    title: const Text(
      'Seguimiento',
      style: TextStyle(
        fontFamily: 'Poppins-Regular',
        fontSize: 23,
        color: Colors.white,
      ),
    ),
  );
}