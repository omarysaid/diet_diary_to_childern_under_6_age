class Diet {
  final int id;
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

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      id: json['diet_id'],
      imageUrl: json['image'],
      fromAge: json['from_age'],
      toAge: json['to_age'],
      fromWeight: json['from_weight'],
      toWeight: json['to_weight'],
      dietName: json['name'],
      description: json['description'],
    );
  }
}
