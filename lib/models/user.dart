class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final String maritalStatus;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.maritalStatus,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
      maritalStatus: data['maritalStatus'] ?? '',
    );
  }
}
