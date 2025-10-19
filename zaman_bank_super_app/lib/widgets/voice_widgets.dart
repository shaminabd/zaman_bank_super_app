import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/voice_service.dart';

class VoiceButton extends StatefulWidget {
  final Function(String) onTextReceived;
  final bool isDisabled;

  const VoiceButton({
    super.key,
    required this.onTextReceived,
    this.isDisabled = false,
  });

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  bool _isRecording = false;
  bool _isProcessing = false;

  Future<void> _startRecording() async {
    try {
      setState(() {
        _isRecording = true;
      });

      _showSnackBar('Говорите... Запись идет');
      
      final text = await VoiceService.simulateRecording();
      
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });
      
      if (text.isNotEmpty && !text.contains('Ошибка') && !text.contains('не распознана')) {
        widget.onTextReceived(text);
        _showSnackBar('Речь распознана: $text');
      } else {
        _showSnackBar('Не удалось распознать речь. Попробуйте еще раз.');
      }
      
      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      _showSnackBar('Ошибка записи: $e');
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isRecording 
            ? Colors.red 
            : _isProcessing 
                ? Colors.orange 
                : AppColors.zamanPersianGreen,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (_isRecording ? Colors.red : AppColors.zamanPersianGreen).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: AppColors.white,
                size: 22,
              ),
        onPressed: widget.isDisabled || _isRecording || _isProcessing ? null : _startRecording,
      ),
    );
  }
}

class PlayAudioButton extends StatefulWidget {
  final String text;
  final bool isDisabled;

  const PlayAudioButton({
    super.key,
    required this.text,
    this.isDisabled = false,
  });

  @override
  State<PlayAudioButton> createState() => _PlayAudioButtonState();
}

class _PlayAudioButtonState extends State<PlayAudioButton> {
  bool _isPlaying = false;

  Future<void> _playAudio() async {
    try {
      setState(() {
        _isPlaying = true;
      });

      // Convert text to speech using OpenAI TTS
      await VoiceService.textToSpeech(widget.text);
      
      // Simulate audio playback (in real app, you'd play the audio)
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isPlaying = false;
      });
      
      _showSnackBar('Аудио воспроизведено: ${widget.text.substring(0, 20)}...');
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      _showSnackBar('Ошибка воспроизведения: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _isPlaying ? Colors.blue : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isPlaying ? Colors.blue : AppColors.zamanPersianGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isPlaying ? Colors.blue : AppColors.zamanPersianGreen).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: _isPlaying
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 18,
              ),
        onPressed: widget.isDisabled ? null : _playAudio,
      ),
    );
  }
}