class Nutritionist {
  final int id; // Add id field
  final String username;
  final String phone;
  final String role;

  Nutritionist({
    required this.id,
    required this.username,
    required this.phone,
    required this.role,
  });

  String getInitials() {
    List<String> nameParts = username.split(' ');
    String initials = '';
    int numWords = nameParts.length;

    if (numWords > 0) {
      initials += nameParts[0][0].toUpperCase();
      if (numWords > 1) {
        initials += nameParts[numWords - 1][0].toUpperCase();
      }
    }

    return initials;
  }

  factory Nutritionist.fromJson(Map<String, dynamic> json) {
    return Nutritionist(
      id: json['id'], // Assign id from JSON data
      username: json['username'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
