import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goal.dart';
import 'auth_service.dart';

class GoalService {
  static const String baseUrl = 'http://localhost:8080/api/goals';
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getStoredToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Goal> createGoal({
    required String userId,
    required String title,
    required double amountTarget,
    required DateTime deadlineDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'userId': userId,
        'title': title,
        'amountTarget': amountTarget,
        'deadlineDate': deadlineDate.toIso8601String().split('T')[0],
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Goal.fromJson(data);
      } else {
        throw Exception('Failed to create goal');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<List<Goal>> getGoalsByUserId(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Goal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch goals');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Goal> getGoalById(String goalId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$goalId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Goal.fromJson(data);
      } else {
        throw Exception('Failed to fetch goal');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Goal> updateGoal({
    required String goalId,
    required String title,
    required double amountTarget,
    required DateTime deadlineDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'title': title,
        'amountTarget': amountTarget,
        'deadlineDate': deadlineDate.toIso8601String().split('T')[0],
      };

      final response = await http.put(
        Uri.parse('$baseUrl/$goalId'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Goal.fromJson(data);
      } else {
        throw Exception('Failed to update goal');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<double> getUserBalance(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/users/$userId/balance'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data ?? 0).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }

  static Future<void> deleteGoal(String goalId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/$goalId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete goal');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
