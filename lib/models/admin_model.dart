class AdminModel {
  final String uid;
  final String name;
  final String email;
  final String hospitalName;
  final String hospitalAddress;
  final String phoneNumber;

  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.phoneNumber,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      hospitalName: map['hospitalName'],
      hospitalAddress: map['hospitalAddress'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
