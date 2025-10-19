class User {
  final String id;
  final String firstName;
  final String lastName;
  final String iin;
  final String phoneNumber;
  final double balance;
  final String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.iin,
    required this.phoneNumber,
    required this.balance,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      iin: json['iin'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'iin': iin,
      'phoneNumber': phoneNumber,
      'balance': balance,
      'token': token,
    };
  }
}

class UserRegistrationRequest {
  final String firstName;
  final String lastName;
  final String iin;
  final String phoneNumber;
  final String password;
  final bool awarenessLimit;

  UserRegistrationRequest({
    required this.firstName,
    required this.lastName,
    required this.iin,
    required this.phoneNumber,
    required this.password,
    this.awarenessLimit = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'iin': iin,
      'phoneNumber': phoneNumber,
      'password': password,
      'awarenessLimit': awarenessLimit,
    };
  }
}

class UserLoginRequest {
  final String iin;
  final String password;

  UserLoginRequest({
    required this.iin,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'iin': iin,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String userId;
  final String firstName;
  final String lastName;
  final String iin;
  final String phoneNumber;
  final double balance;
  final String message;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.iin,
    required this.phoneNumber,
    required this.balance,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      iin: json['iin'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      message: json['message'] ?? '',
    );
  }
}
