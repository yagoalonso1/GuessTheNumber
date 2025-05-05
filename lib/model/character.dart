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

  Character({
    required this.name,
    required this.species,
    required this.house,
    required this.gender,
    required this.dateOfBirth,
    required this.wizard,
    required this.ancestry,
    required this.hogwartsStudent,
    required this.hogwartsStaff,
    required this.alive,
    required this.image,
  });

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