import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/viewmodel.dart';
import 'view/character_list_screen.dart';

// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => mainViewModel(),
      child: MaterialApp(
        title: 'hogwAPI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CharacterListScreen(),
      ),
    );
  }
}
