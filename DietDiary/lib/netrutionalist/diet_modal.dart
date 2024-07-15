// diet_model.dart
class Diet {
  final String id;
  final String imageUrl;
  final String fromAge;
  final String toAge;
  final String fromWeight;
  final String toWeight;
  final String dietName;
  final String description;

  Diet({
    required this.id,
    required this.imageUrl,
    required this.fromAge,
    required this.toAge,
    required this.fromWeight,
    required this.toWeight,
    required this.dietName,
    required this.description,
  });
}
