class UserModel {
  String uid;
  String role;
  String name;
  String lastName;
  String email;
  String phoneNo;

  UserModel({
    required this.uid,
    required this.role,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'role': role,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phoneNo': phoneNo,
    };
  }
}
