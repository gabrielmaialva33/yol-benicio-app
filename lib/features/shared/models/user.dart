class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String department;
  final bool isActive;
  final String? photoUrl;
  final String? phone;
  final DateTime? joinDate;
  final Map<String, dynamic>? permissions;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    this.isActive = true,
    this.photoUrl,
    this.phone,
    this.joinDate,
    this.permissions,
  });

  // Helper methods
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String get fullName => name;

  String get shortName {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first} ${parts.last[0]}.';
    }
    return name;
  }

  bool get isSenior => role.contains('Sócio') || role.contains('Sênior');

  bool get canApprove => permissions?['canApprove'] ?? isSenior;

  bool get canCreateFolders => permissions?['canCreateFolders'] ?? true;

  bool get canEditBilling => permissions?['canEditBilling'] ?? isSenior;
}
