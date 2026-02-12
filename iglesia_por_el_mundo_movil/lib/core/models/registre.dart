class RegistreResponse {
  final String token;
  final UserResult user;

  RegistreResponse({
    required this.token,
    required this.user,
  });

  factory RegistreResponse.fromJson(Map<String, dynamic> json) {
    return RegistreResponse(
      token: json['token'] as String,
      user: UserResult.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  RegistreResponse copyWith({
    String? token,
    UserResult? user,
  }) {
    return RegistreResponse(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class UserResult {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserResult({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserResult copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserResult(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
