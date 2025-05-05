import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/viewmodel.dart';
import 'view/character_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => mainViewModel(),
      child: MaterialApp(
        title: 'Harry Potter API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.lightBlue[300]!, // Azul claro como color principal
            secondary: Colors.amber[700]!, // Ámbar como color secundario
            tertiary: Colors.teal[300], // Teal como color terciario
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            background: Colors.grey[100]!,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightBlue[300],
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.lightBlue[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.lightBlue[300]!, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.lightBlue[700],
            ),
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey[300],
            thickness: 1,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const CharacterListScreen(),
      ),
    );
  }
}
