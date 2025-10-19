import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceService {
  static const String openAiApiKey = 'sk-proj-qqVgeyuwglNVpPlz2jsvTuUUM9WBEmX8WuB7lO0-8fJi3DsSB2LFkaq5NXWHYw2VpdVOYx0IA';

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

  static Future<String> simulateRecording() async {
    try {
      final recorder = AudioRecorder();
      final tempDir = await getTemporaryDirectory();
      final audioFile = File('${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a');
      
      if (await recorder.hasPermission()) {
        await recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: audioFile.path,
        );
        
        await Future.delayed(const Duration(seconds: 3));
        
        await recorder.stop();
        
        final recognizedText = await speechToText(audioFile.path);
        
        await audioFile.delete();
        
        return recognizedText.isNotEmpty ? recognizedText : 'Речь не распознана';
      } else {
        return 'Нет разрешения на запись';
      }
    } catch (e) {
      return 'Ошибка записи: $e';
    }
  }

  static Future<bool> hasMicrophonePermission() async {
    final recorder = AudioRecorder();
    return await recorder.hasPermission();
  }
}