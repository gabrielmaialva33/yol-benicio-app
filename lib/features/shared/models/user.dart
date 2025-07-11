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
}
