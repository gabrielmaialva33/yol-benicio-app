class User {
  final int id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  String get shortName {
    if (fullName.isEmpty) {
      return '';
    }
    final parts = fullName.split(' ');
    if (parts.length > 1) {
      return '${parts.first} ${parts.last}';
    }
    return fullName;
  }
}
