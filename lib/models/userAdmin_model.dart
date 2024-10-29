class UserAdmin {
  final String id;
  final String email;
  final String displayName;
  final String roles;

  UserAdmin({
    required this.id,
    required this.email,
    required this.displayName,
    required this.roles,
  });

  // Phương thức để tạo đối tượng UserAdmin từ dữ liệu Firebase
  factory UserAdmin.fromMap(Map<String, dynamic> data, String id) {
    return UserAdmin(
      id: id,
      email: data['Email'] ?? '',
      displayName: data['DisplayName'] ?? '',
      roles: data['Roles'] ?? '',
    );
  }

  // Phương thức để chuyển đổi đối tượng UserAdmin thành Map để lưu trữ vào Firebase
  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'DisplayName': displayName,
      'Roles': roles,
    };
  }
}
