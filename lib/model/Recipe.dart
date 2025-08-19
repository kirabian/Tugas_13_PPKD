class Recipe {
  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final int isPremium; // 0 for false, 1 for true
  final String ingredients; // String dengan format bahan1||bahan2||bahan3
  final String steps; // String dengan format langkah1||langkah2||langkah3

  Recipe({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isPremium,
    required this.ingredients,
    required this.steps,
  });

  // Konversi dari Recipe object ke Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'isPremium': isPremium,
      'ingredients': ingredients,
      'steps': steps,
    };
  }

  // Konversi dari Map object ke Recipe object
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
      isPremium: map['isPremium'],
      ingredients: map['ingredients'] ?? '',
      steps: map['steps'] ?? '',
    );
  }

  // Helper method untuk mendapatkan List bahan
  List<String> getIngredientsList() {
    return ingredients.split('||');
  }

  // Helper method untuk mendapatkan List langkah-langkah
  List<String> getStepsList() {
    return steps.split('||');
  }
}
