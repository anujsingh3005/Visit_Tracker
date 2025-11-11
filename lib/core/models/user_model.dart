class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'salesperson' or 'manager'
  final String phone;
  final String address;
  final String designation;
  final String profileImageUrl; // Added for the profile picture

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
    required this.address,
    required this.designation,
    required this.profileImageUrl,
  });
}