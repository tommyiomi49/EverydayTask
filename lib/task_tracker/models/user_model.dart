class UserModel {
  final int? userId;
  final String fName;
  final String lName;
  final String gmail;
  final String password;

  UserModel({
    this.userId,
    required this.fName,
    required this.lName,
    required this.gmail,
    required this.password,
  });

  String get fullName => '$fName $lName'.trim();
  String get initials {
    final f = fName.isNotEmpty ? fName[0].toUpperCase() : '';
    final l = lName.isNotEmpty ? lName[0].toUpperCase() : '';
    return '$f$l';
  }

  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'user_id': userId,
      'fName': fName,
      'lName': lName,
      'gmail': gmail,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] as int?,
      fName: map['fName'] as String? ?? '',
      lName: map['lName'] as String? ?? '',
      gmail: map['gmail'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  UserModel copyWith({
    int? userId,
    String? fName,
    String? lName,
    String? gmail,
    String? password,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      gmail: gmail ?? this.gmail,
      password: password ?? this.password,
    );
  }
}

