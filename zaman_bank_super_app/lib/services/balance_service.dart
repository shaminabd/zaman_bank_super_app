import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class BalanceService {
  static const String baseUrl = 'http://localhost:8080/api/users';
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getStoredToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<double> getBalance(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/balance'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data ?? 0).toDouble();
      } else {
        throw Exception('Failed to fetch balance');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<User> addBalance(String userId, double amount) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'amount': amount,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/$userId/balance'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to add balance');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
