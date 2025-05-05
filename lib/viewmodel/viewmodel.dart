import 'package:flutter/material.dart';
import '../model/character.dart';
import '../service/api_service.dart';

// Enum para representar los diferentes estados del ViewModel (mientras carga los datos de la API.)
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
  
  // Lista de personajes filtrados para la búsqueda
  List<Character> _filteredCharacters = [];
  List<Character> get filteredCharacters => _filteredCharacters;
  
  // Texto de búsqueda actual
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

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
      _filteredCharacters = _characters; // Inicialmente todos los personajes

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
  
  // Método para buscar personajes por nombre
  void searchCharacters(String query) {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredCharacters = _characters;
    } else {
      _filteredCharacters = _characters.where((character) => 
        character.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
    
    if (_filteredCharacters.isEmpty && _characters.isNotEmpty) {
      _setState(ViewState.empty);
    } else if (_characters.isNotEmpty) {
      _setState(ViewState.success);
    }
    
    notifyListeners();
  }
  
  // Método para limpiar la búsqueda
  void clearSearch() {
    _searchQuery = '';
    _filteredCharacters = _characters;
    
    if (_characters.isEmpty) {
      _setState(ViewState.empty);
    } else {
      _setState(ViewState.success);
    }
    
    notifyListeners();
  }
}
