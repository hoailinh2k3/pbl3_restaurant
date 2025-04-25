class UserModel {
  final String fullName;
  final String phoneNumber;
  final DateTime birthday;
  final String gender;
  final String role;
  final int branchId;
  final dynamic picture;
  final DateTime createAt;

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.birthday,
    required this.gender,
    required this.role,
    required this.branchId,
    this.picture,
    required this.createAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = (json['user'] is Map<String, dynamic>)
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserModel(
      fullName: data['fullName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      birthday: DateTime.parse(data['birthday'] as String),
      gender: data['gender'] as String,
      role: data['role'] as String,
      branchId: data['branchId'] as int,
      picture: data['picture'],
      createAt: DateTime.tryParse(data['createAt'] as String) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthday':
          '${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}',
      'genderName': gender,
      'roleName': role,
      'branchId': branchId,
      'picture': picture,
      'createAt': createAt.toIso8601String(),
    };
  }
}
