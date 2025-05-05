// clase que contiene los atributos de un personaje;
class Character {
  final String name;
  final String species;
  final String house;
  final String gender;
  final String dateOfBirth;
  final bool wizard;
  final String ancestry;
  final bool hogwartsStudent;
  final bool hogwartsStaff;
  final bool alive;
  final String image;

  // Constructor de la clase Character, todos los atributos son obligatorios
  Character({
    required this.name, // nombre
    required this.species, // especie
    required this.house, // casa
    required this.gender, // género
    required this.dateOfBirth, // fecha de nacimiento
    required this.wizard, // mago
    required this.ancestry, // ascendencia
    required this.hogwartsStudent, // es estudiante de Hogwarts?
    required this.hogwartsStaff, // personal de Hogwarts?
    required this.alive, // está vivo?
    required this.image, // imagen
  });
  // Método para crear una instancia de Character a partir de un mapa JSON
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      house: json['house'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      wizard: json['wizard'] ?? false,
      ancestry: json['ancestry'] ?? '',
      hogwartsStudent: json['hogwartsStudent'] ?? false,
      hogwartsStaff: json['hogwartsStaff'] ?? false,
      alive: json['alive'] ?? true,
      image: json['image'] ?? '',
    );
  }
  // Método para convertir una instancia de Character a un mapa JSON (para el extra de crear un personaje)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'house': house,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'wizard': wizard,
      'ancestry': ancestry,
      'hogwartsStudent': hogwartsStudent,
      'hogwartsStaff': hogwartsStaff,
      'alive': alive,
      'image': image,
    };
  }
}
