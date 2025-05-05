import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/character.dart';
import '../viewmodel/viewmodel.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Cargar los personajes al iniciar la pantalla
    Future.microtask(() => 
      Provider.of<mainViewModel>(context, listen: false).fetchCharacters()
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes de Harry Potter'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<mainViewModel>(
              builder: (context, viewModel, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar personaje por nombre...',
                    prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.clearSearch();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    viewModel.searchCharacters(value);
                  },
                );
              },
            ),
          ),
          
          // Lista de personajes
          Expanded(
            child: Consumer<mainViewModel>(
              builder: (context, viewModel, child) {
                // Mostrar diferentes widgets dependiendo del estado
                switch (viewModel.state) {
                  case ViewState.loading:
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  
                  case ViewState.error:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: theme.colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${viewModel.errorMessage}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.fetchCharacters(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  
                  case ViewState.empty:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          viewModel.searchQuery.isNotEmpty
                            ? Text(
                                'No se encontraron resultados para "${viewModel.searchQuery}"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                'No se encontraron personajes',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                          if (viewModel.searchQuery.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                viewModel.clearSearch();
                              },
                              child: const Text('Limpiar búsqueda'),
                            ),
                        ],
                      ),
                    );
                  
                  case ViewState.success:
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: viewModel.filteredCharacters.length,
                      itemBuilder: (context, index) {
                        final character = viewModel.filteredCharacters[index];
                        return CharacterCard(character: character);
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Información del personaje (a la izquierda)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del personaje
                  Text(
                    character.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: getHouseColor(character.house, theme),
                    ),
                  ),
                  const Divider(),
                  
                  // Detalles del personaje
                  InfoRow(title: 'Species', value: character.species),
                  InfoRow(title: 'Gender', value: character.gender),
                  InfoRow(title: 'House', value: character.house),
                  InfoRow(title: 'Date Of Birth', value: character.dateOfBirth),
                  InfoRow(title: 'is a Wizard or Bridge?', value: character.wizard ? 'Yes' : 'No'),
                  InfoRow(title: 'Ancestry', value: character.ancestry),
                  InfoRow(title: 'is Hogwart\'s Student?', value: character.hogwartsStudent ? 'Yes' : 'No'),
                  InfoRow(title: 'is Hogwart\'s Staff?', value: character.hogwartsStaff ? 'Yes' : 'No'),
                  InfoRow(title: 'Estado', value: character.alive ? 'Vivo' : 'Fallecido'),
                ],
              ),
            ),
            
            // Espaciador
            const SizedBox(width: 16),
            
            // Imagen del personaje (a la derecha)
            if (character.image.isNotEmpty)
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: getHouseColor(character.house, theme),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      character.image,
                      width: 500,
                      height: 500,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, _) => Container(
                        width: 500,
                        height: 500,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 60, color: Colors.grey[500]),
                      ),
                      loadingBuilder: (ctx, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 500,
                          height: 500,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // Función para obtener el color según la casa de Hogwarts
  Color getHouseColor(String house, ThemeData theme) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return Colors.red[700] ?? Colors.red;
      case 'slytherin':
        return Colors.green[800] ?? Colors.green;
      case 'ravenclaw':
        return Colors.blue[800] ?? Colors.blue;
      case 'hufflepuff':
        return Colors.amber[700] ?? Colors.amber;
      default:
        return theme.colorScheme.primary;
    }
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'NaN' : value,
              style: TextStyle(
                color: value.isEmpty ? theme.colorScheme.error : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}