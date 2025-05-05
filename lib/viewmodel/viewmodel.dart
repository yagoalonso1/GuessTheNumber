import 'package:flutter/material.dart';
import '../model/character.dart';
import '../service/api_service.dart';

// Enum para representar los diferentes estados del ViewModel
enum ViewState {
  loading, // Datos cargando.
  success, // Datos cargados correctamente.
  error, // Error al cargar los datos
  empty // Datos vacíos.
}

class mainViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Estado actual de la vista
  ViewState _state = ViewState.loading;
  ViewState get state => _state;

  // Lista de todos los personajes
  List<Character> _characters = [];
  List<Character> get characters => _characters;

  // Mensaje de error
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Método para actualizar el estado
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  // Método para cargar los personajes desde la API
  Future<void> fetchCharacters() async {
    _setState(ViewState.loading);

    try {
      _characters = await _apiService.getCharacters();

      if (_characters.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.success);
      }
    } catch (e) {
      _errorMessage = 'Error al cargar los personajes: ${e.toString()}';
      _setState(ViewState.error);
    }
  }
}
