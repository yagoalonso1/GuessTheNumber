import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/character.dart';

class ApiService {
  // URL base de la API de Harry Potter
  final String baseUrl = 'https://hp-api.onrender.com/api';
  
  // Método para obtener todos los personajes
  Future<List<Character>> getCharacters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/characters'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Character.fromJson(data)).toList();
      } else {
        throw Exception('Error al cargar personajes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Método para obtener personajes de una casa específica
  Future<List<Character>> getCharactersByHouse(String house) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/characters/house/$house'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Character.fromJson(data)).toList();
      } else {
        throw Exception('Error al cargar personajes de $house: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
} 