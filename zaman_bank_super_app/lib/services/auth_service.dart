import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api/users';
  
  static Future<LoginResponse> login(UserLoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<User> register(UserRegistrationRequest registrationRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(registrationRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setString('auth_token', user.token ?? '');
  }

  static Future<User?> getStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userJson = jsonDecode(userData);
        return User.fromJson(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.remove('auth_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  static Future<User> getCurrentUser() async {
    try {
      final token = await getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to get current user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<User> getUserByPhoneNumber(String phoneNumber) async {
    try {
      final token = await getStoredToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/phone/$phoneNumber'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to get user by phone: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
