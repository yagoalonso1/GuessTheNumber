import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/character.dart';
import '../viewmodel/viewmodel.dart';

// Pantalla principal.
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

// Estado de la pantalla principal.
class _CharacterListScreenState extends State<CharacterListScreen> {
  final TextEditingController _searchController = TextEditingController();
    
// Inicialización de la pantalla
  @override
  void initState() {
    super.initState();
    // Cargar los personajes al iniciar la pantalla
    Future.microtask(() => 
      Provider.of<mainViewModel>(context, listen: false).fetchCharacters()
    );
  }
 // Liberación de recursos
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // Construcción de la interfaz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hogwAPI'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<mainViewModel>(
              builder: (context, viewModel, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar personaje por nombre...',
                    prefixIcon: const Icon(Icons.search),
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
                      borderRadius: BorderRadius.circular(10),
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
                    return const Center(child: CircularProgressIndicator());
                  
                  case ViewState.error:
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${viewModel.errorMessage}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
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
                          const Icon(Icons.search_off, size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          viewModel.searchQuery.isNotEmpty
                            ? Text(
                                'No se encontraron resultados para "${viewModel.searchQuery}"',
                                textAlign: TextAlign.center,
                              )
                            : const Text('No se encontraron personajes'),
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
                      padding: const EdgeInsets.all(8),
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

// Card para mostrar los personajes recogidos por la API.
class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      character.image,
                      width: 500,
                      height: 500,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, _) => Container(
                        width: 500,
                        height: 500,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 60),
                      ),
                      loadingBuilder: (ctx, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 500,
                          height: 500,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
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
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$title:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'NaN' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}