import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/character_view_model.dart';
import 'view/character_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterViewModel(),
      child: MaterialApp(
        title: 'Harry Potter API',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CharacterListScreen(),
      ),
    );
  }
}
