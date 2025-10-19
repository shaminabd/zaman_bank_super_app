import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'auth_service.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:8080/api/chat';
  static const String openAiApiKey = 'sk-proj-qqVgeyBfBzBZueYukdIaXlz2jsvTuUUM9WBEmX8WuB7lO0-8fJi3DsSB2LFkaq5NXWHYw2VpdVOYx0IA'; // Replace with actual API key
  
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getStoredToken();
    print('ChatService: Retrieved token: ${token != null ? "Token exists" : "No token"}');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<ChatResponse> sendMessage({
    required String message,
    List<String>? fileIds,
    String? vectorStoreId,
  }) async {
    try {
      print('ChatService: Preparing request for message: $message');
      final headers = await _getHeaders();
      print('ChatService: Headers: $headers');
      
      final body = {
        'message': message,
        'fileIds': fileIds ?? ["file-9ZVzsGAiviY12kz7L3ZsEY", "file-MRWwbiCFa4zQX1PDqHJb8z"],
        'vectorStoreId': vectorStoreId ?? "vs_68f42edf4b90819187f50275a9c3001c",
      };
      
      print('ChatService: Request body: $body');
      print('ChatService: Sending to URL: $baseUrl/with-context');

      final response = await http.post(
        Uri.parse('$baseUrl/with-context'),
        headers: headers,
        body: jsonEncode(body),
      );

      print('ChatService: Response status: ${response.statusCode}');
      print('ChatService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('ChatService: Error occurred: $e');
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<ChatResponse> sendMessageWithContext({
    required String message,
    required String contextText,
    List<String>? fileIds,
    String? vectorStoreId,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'message': message,
        'contextText': contextText,
        if (fileIds != null) 'fileIds': fileIds,
        if (vectorStoreId != null) 'vectorStoreId': vectorStoreId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/with-context'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Failed to send message with context');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  static Future<void> sendSystemMessage({
    required String message,
    bool isUnread = false,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'message': message,
        'isSystemMessage': true,
        'isUnread': isUnread,
        'sender': 'System',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/system-message'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        print('Failed to send system message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending system message: $e');
    }
  }

  // Voice-to-Text using OpenAI Whisper
  static Future<String> speechToText(String audioFilePath) async {
    try {
      final file = File(audioFilePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
      );

      request.headers['Authorization'] = 'Bearer $openAiApiKey';
      request.files.add(await http.MultipartFile.fromPath('file', audioFilePath));
      request.fields['model'] = 'whisper-1';
      request.fields['language'] = 'ru'; // Russian language

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['text'] ?? '';
      } else {
        throw Exception('Speech-to-text failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Speech-to-text error: $e');
    }
  }

  // Text-to-Speech using OpenAI TTS
  static Future<String> textToSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/audio/speech'),
        headers: {
          'Authorization': 'Bearer $openAiApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'tts-1',
          'input': text,
          'voice': 'nova', // You can use: alloy, echo, fable, onyx, nova, shimmer
          'response_format': 'mp3',
        }),
      );

      if (response.statusCode == 200) {
        // Save audio file to temporary directory
        final tempDir = await getTemporaryDirectory();
        final audioFile = File('${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
        await audioFile.writeAsBytes(response.bodyBytes);
        return audioFile.path;
      } else {
        throw Exception('Text-to-speech failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Text-to-speech error: $e');
    }
  }
}

class ChatResponse {
  final String response;
  final String messageId;
  final int timestamp;
  final bool? contextUsed;
  final Map<String, dynamic>? functionCall;

  ChatResponse({
    required this.response,
    required this.messageId,
    required this.timestamp,
    this.contextUsed,
    this.functionCall,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      messageId: json['messageId'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      contextUsed: json['contextUsed'],
      functionCall: json['functionCall'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'messageId': messageId,
      'timestamp': timestamp,
      if (contextUsed != null) 'contextUsed': contextUsed,
      if (functionCall != null) 'functionCall': functionCall,
    };
  }
}
