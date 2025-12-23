class DonorSubmission {
  DonorSubmission({
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.bloodType,
    required this.maritalStatus,
    required this.hospital,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String name;
  final String phone;
  final String address;
  final String gender;
  final String bloodType;
  final String maritalStatus;
  final String hospital;
  final DateTime createdAt;
}



