import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  static const String baseUrl = 'http://localhost:8080/api/users';
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getStoredToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<User>> searchUsersByName(String name) async {
    try {
      final headers = await _getHeaders();
      print('UserService: Searching for users with name: $name');
      print('UserService: URL: $baseUrl/search?name=$name');
      print('UserService: Headers: $headers');
      
      final response = await http.get(
        Uri.parse('$baseUrl/search?name=$name'),
        headers: headers,
      );

      print('UserService: Response status: ${response.statusCode}');
      print('UserService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search users: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('UserService: Error occurred: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String iin;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.iin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      iin: json['iin'] ?? '',
    );
  }
}
