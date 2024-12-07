class UserModel {
  String uid;
  String role;
  String name;
  String lastName;
  String email;
  String phoneNo;
  String profilePictureUrl;

  UserModel({
    required this.uid,
    required this.role,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    this.profilePictureUrl = 'assets/profile.jpeg',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'role': role,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phoneNo': phoneNo,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      role: map['role'] ?? 'Employee',
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? 'assets/profile.jpeg',
    );
  }
}
