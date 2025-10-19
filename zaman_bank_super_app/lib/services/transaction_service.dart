import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import '../providers/chat_notification_provider.dart';

class TransactionService {
  static const String baseUrl = 'http://localhost:8080/api/transactions';
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getStoredToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Transaction>> getTransactionsByUserId(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Transaction> createTransaction({
    required String senderId,
    required String receiverId,
    required double amount,
    required String description,
    BuildContext? context,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'senderId': senderId,
        'receiverId': receiverId,
        'amount': amount,
        'description': description,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final transaction = Transaction.fromJson(data);
        
        // Store transaction ID for categorization
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('latest_transaction_id', transaction.id);
        
        // Send categorization message after successful transaction
        _sendCategorizationMessage(transaction, context);
        
        return transaction;
      } else {
        throw Exception('Failed to create transaction');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Transaction> getTransactionById(String transactionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$transactionId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Transaction.fromJson(data);
      } else {
        throw Exception('Failed to fetch transaction');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<Transaction?> getLatestTransactionByUserId(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId/latest'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Transaction.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // No transactions found
      } else {
        throw Exception('Failed to fetch latest transaction');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<void> _sendCategorizationMessage(Transaction transaction, BuildContext? context) async {
    try {
      // Set unread flag in provider to show red indicator
      if (context != null) {
        Provider.of<ChatNotificationProvider>(context, listen: false)
            .setUnreadMessages(true);
      }
      
      // Store flag to automatically show category selection
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_category_selection', true);
      
    } catch (e) {
      // Don't fail transaction if categorization message fails
      print('Failed to send categorization message: $e');
    }
  }
}

class Transaction {
  final String id;
  final String senderId;
  final String receiverId;
  final double amount;
  final String description;
  final DateTime sendDate;
  final bool isHalal;

  Transaction({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.description,
    required this.sendDate,
    required this.isHalal,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      sendDate: DateTime.parse(json['sendDate'] ?? DateTime.now().toIso8601String()),
      isHalal: json['isHalal'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'amount': amount,
      'description': description,
      'sendDate': sendDate.toIso8601String(),
      'isHalal': isHalal,
    };
  }
}
