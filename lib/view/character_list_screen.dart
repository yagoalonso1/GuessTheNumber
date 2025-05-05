import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/character.dart';
import '../model/character_view_model.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los personajes al iniciar la pantalla
    Future.microtask(() => 
      Provider.of<CharacterViewModel>(context, listen: false).fetchCharacters()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes de Harry Potter'),
      ),
      body: Consumer<CharacterViewModel>(
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
              return const Center(
                child: Text('No se encontraron personajes'),
              );
            
            case ViewState.success:
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: viewModel.characters.length,
                itemBuilder: (context, index) {
                  final character = viewModel.characters[index];
                  return CharacterCard(character: character);
                },
              );
          }
        },
      ),
    );
  }
}

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del personaje
            if (character.image.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    character.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, _) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                    loadingBuilder: (ctx, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 16),
            
            // Nombre del personaje
            Text(
              character.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            
            // Detalles del personaje
            InfoRow(title: 'Especie', value: character.species),
            InfoRow(title: 'Género', value: character.gender),
            InfoRow(title: 'Casa', value: character.house),
            InfoRow(title: 'Fecha de nacimiento', value: character.dateOfBirth),
            InfoRow(title: 'Mago/Bruja', value: character.wizard ? 'Sí' : 'No'),
            InfoRow(title: 'Ascendencia', value: character.ancestry),
            InfoRow(title: 'Estudiante de Hogwarts', value: character.hogwartsStudent ? 'Sí' : 'No'),
            InfoRow(title: 'Personal de Hogwarts', value: character.hogwartsStaff ? 'Sí' : 'No'),
            InfoRow(title: 'Estado', value: character.alive ? 'Vivo' : 'Fallecido'),
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
              value.isEmpty ? 'Desconocido' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.black38 : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 