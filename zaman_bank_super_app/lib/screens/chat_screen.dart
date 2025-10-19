import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/navigation_utils.dart';
import '../services/chat_service.dart';
import '../services/transaction_service.dart';
import '../services/goal_service.dart';
import '../services/user_service.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_notification_provider.dart';
import '../services/auth_service.dart';
import '../widgets/category_selection_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String? predefinedText;
  
  const ChatScreen({super.key, this.predefinedText});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 2;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isShowingCategorySelection = false;
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Привет! Я ваш персональный помощник Zaman Bank. Как я могу помочь вам сегодня?",
      isUser: false,
      sender: "Zaman Assistant",
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.predefinedText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messageController.text = widget.predefinedText!;
      });
    }
    _checkForPendingCategorizationMessage();
    // Mark all unread messages as read when chat opens
    _markMessagesAsRead();
  }

  void _checkForPendingCategorizationMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final showCategorySelection = prefs.getBool('show_category_selection') ?? false;
      
      if (showCategorySelection) {
        // Add message asking user to categorize their latest transaction
        setState(() {
          _messages.add(
            ChatMessage(
              text: "🔍 **Категоризация транзакции**\n\nДля вашей последней транзакции выберите категорию цели:",
              isUser: false,
              sender: "Zaman Assistant",
              timestamp: DateTime.now(),
              isUnread: true,
              isSystemMessage: true,
            ),
          );
          _isShowingCategorySelection = true;
        });
        
        // Clear the flag
        await prefs.remove('show_category_selection');
        
        // Scroll to bottom to show the category selection
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      print('Error checking for pending categorization message: $e');
    }
  }

  void _markMessagesAsRead() {
    setState(() {
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].isUnread) {
          _messages[i] = ChatMessage(
            text: _messages[i].text,
            isUser: _messages[i].isUser,
            sender: _messages[i].sender,
            timestamp: _messages[i].timestamp,
            isUnread: false,
            isSystemMessage: _messages[i].isSystemMessage,
          );
        }
      }
    });
    
    // Mark as read in provider
    Provider.of<ChatNotificationProvider>(context, listen: false).markAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zamanCloud,
      appBar: AppBar(
        backgroundColor: AppColors.zamanCloud,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.zamanPersianGreen,
                    AppColors.zamanPersianGreen.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zamanPersianGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: AppColors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zaman Assistant',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Онлайн',
                  style: TextStyle(
                    color: AppColors.grey.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.black),
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Input Area or Category Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: _isShowingCategorySelection
                  ? CategorySelectionWidget(
                      onCategorySelected: _handleCategorySelection,
                      isDisabled: _isTyping,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.zamanCloud,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: AppColors.zamanPersianGreen.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Напишите сообщение...',
                                hintStyle: TextStyle(
                                  color: AppColors.grey.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              maxLines: null,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildCommandsButton(),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.zamanPersianGreen,
                                AppColors.zamanPersianGreen.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.zamanPersianGreen.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: AppColors.white,
                              size: 22,
                            ),
                            onPressed: _isTyping ? null : () {
                              if (_messageController.text.trim().isNotEmpty) {
                                _sendMessage(_messageController.text.trim());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigation is handled in the BottomNavigation widget itself
        },
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'images/image.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image fails to load
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.zamanPersianGreen,
                          AppColors.zamanPersianGreen.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.zamanCloud,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Печатает',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.zamanPersianGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zamanPersianGreen.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'images/image.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image fails to load
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.zamanPersianGreen,
                            AppColors.zamanPersianGreen.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smart_toy_outlined,
                        color: AppColors.white,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isUser
                        ? LinearGradient(
                            colors: [
                              AppColors.zamanPersianGreen,
                              AppColors.zamanPersianGreen.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: message.isUser ? null : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 20),
                    ),
                    border: message.isUnread && !message.isUser
                        ? Border.all(color: Colors.red, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: message.isUnread && !message.isUser
                            ? Colors.red.withOpacity(0.2)
                            : Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? AppColors.white : AppColors.black,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.zamanSolar,
                    AppColors.zamanSolar.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zamanSolar.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.black,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Сейчас';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else {
      return '${timestamp.day}.${timestamp.month}.${timestamp.year}';
    }
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.zamanPersianGreen,
                          AppColors.zamanPersianGreen.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Возможности Zaman Assistant',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem(
                    icon: Icons.track_changes_outlined,
                    title: 'Halal Intention Tracker',
                    description: 'Понимает смысл каждой траты и отслеживает осознанность расходов.',
                    onTap: () {
                      Navigator.of(context).pop();
                      _addMessage('Расскажите мне о Halal Intention Tracker');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Halal Life Balance Dashboard',
                    description: 'Анализирует траты по категориям и показывает баланс жизненных приоритетов.',
                    onTap: () {
                      Navigator.of(context).pop();
                      _addMessage('Покажите мой Halal Life Balance Dashboard');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.mic_outlined,
                    title: 'Голосовые переводы',
                    description: 'Делает переводы по голосовой команде (кому, сколько и за что).',
                    onTap: () {
                      Navigator.of(context).pop();
                      _addMessage('Как работают голосовые переводы?');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.verified_outlined,
                    title: 'Halal Compliance Check',
                    description: 'Автоматически определяет, халяльна ли операция, покупка или финансирование.',
                    onTap: () {
                      Navigator.of(context).pop();
                      _addMessage('Проверьте эту операцию на соответствие халяль');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lightbulb_outline,
                    title: 'Персональные финансовые советы',
                    description: 'Дает простые рекомендации по сбережениям, расходам и планированию.',
                    onTap: () {
                      Navigator.of(context).pop();
                      _addMessage('Дай мне персональные финансовые советы');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.zamanCloud,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.zamanPersianGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.zamanPersianGreen,
                        AppColors.zamanPersianGreen.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.zamanPersianGreen.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.grey.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: true,
          sender: "Вы",
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    // Check if this is a goal creation message
    if (message.toLowerCase().startsWith('goal:')) {
      await _handleGoalCreation(message);
      return;
    }

    // Check if this is a transfer message
    if (_isTransferMessage(message)) {
      await _handleTransferCreation(message);
      return;
    }

    // Send regular messages to GPT/LLM backend
    try {
      print('Sending message: $message');
      final response = await ChatService.sendMessage(message: message);
      print('Received response: ${response.response}');
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: response.response,
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      print('Chat error: $e');
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Извините, произошла ошибка: ${e.toString()}",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _handleGoalCreation(String message) async {
    try {
      // Extract the goal description after "goal:"
      final goalDescription = message.substring(5).trim();
      
      // Send a flexible prompt to GPT to parse the goal information
      final prompt = "Извлеки информацию о цели из текста: '$goalDescription'\n\nОтветь ТОЛЬКО в формате:\nTITLE: [название цели]\nAMOUNT: [сумма в тенге, только число]\nDEADLINE: [дата в формате YYYY-MM-DD]\n\nПравила:\n- TITLE: извлеки что покупаем/на что копим (кратко, 1-2 слова)\n- AMOUNT: найди любые упоминания денег и конвертируй в тенге\n  * 'млн', 'миллион' = ×1,000,000\n  * 'тыс', 'тысяч' = ×1,000\n  * 'к' = ×1,000\n  * если только число без единиц, используй как есть\n- DEADLINE: найди любые упоминания времени и конвертируй в дату\n  * 'года', 'лет', 'год' = добавить лет к сегодня\n  * 'месяца', 'месяцев', 'месяц' = добавить месяцев к сегодня\n  * 'дня', 'дней', 'день' = добавить дней к сегодня\n  * если дата указана явно, используй её\n\nЕсли что-то не найдено:\n- TITLE: 'Новая цель'\n- AMOUNT: 50000\n- DEADLINE: через 1 год от сегодня (${DateTime.now().add(const Duration(days: 365)).toIso8601String().split('T')[0]})\n\nПримеры:\n'хочу купить машину за 40 млн через 4 года' → TITLE: машина, AMOUNT: 40000000, DEADLINE: 2028-10-19\n'коплю на квартиру 15 млн на 2 года' → TITLE: квартира, AMOUNT: 15000000, DEADLINE: 2026-10-19\n'нужно 500 тысяч на учебу через полгода' → TITLE: учеба, AMOUNT: 500000, DEADLINE: 2025-04-19";
      
      final response = await ChatService.sendMessage(message: prompt);
      final responseText = response.response;
      
      print('GPT Response for goal creation: $responseText');
      
      // Parse the response
      final lines = responseText.split('\n');
      String? title;
      double? amount;
      String? deadlineText;
      
      for (final line in lines) {
        if (line.startsWith('TITLE:')) {
          title = line.substring(6).trim();
        } else if (line.startsWith('AMOUNT:')) {
          final amountStr = line.substring(7).trim();
          amount = double.tryParse(amountStr);
        } else if (line.startsWith('DEADLINE:')) {
          deadlineText = line.substring(9).trim();
        }
      }
      
      // Fallback parsing if AI didn't follow the format exactly
      if (title == null || amount == null || deadlineText == null) {
        print('AI response did not follow expected format, attempting fallback parsing...');
        
        // Try to extract information from the original goal description
        final lowerDescription = goalDescription.toLowerCase();
        
        // Extract title (look for common patterns)
        if (title == null) {
          // More flexible title extraction
          if (lowerDescription.contains('машину') || lowerDescription.contains('автомобиль') || lowerDescription.contains('машина')) {
            title = 'машина';
          } else if (lowerDescription.contains('квартиру') || lowerDescription.contains('дом') || lowerDescription.contains('квартира')) {
            title = 'квартира';
          } else if (lowerDescription.contains('образование') || lowerDescription.contains('учебу') || lowerDescription.contains('учеба')) {
            title = 'образование';
          } else if (lowerDescription.contains('путешествие') || lowerDescription.contains('отпуск')) {
            title = 'путешествие';
          } else if (lowerDescription.contains('свадьбу') || lowerDescription.contains('свадьба')) {
            title = 'свадьба';
          } else if (lowerDescription.contains('ремонт')) {
            title = 'ремонт';
          } else if (lowerDescription.contains('бизнес') || lowerDescription.contains('стартап')) {
            title = 'бизнес';
          } else {
            // Try to extract any noun after common verbs
            final titleRegex = RegExp(r'(хочу|нужно|коплю|накопить|купить|приобрести)\s+([а-яё]+)', caseSensitive: false);
            final titleMatch = titleRegex.firstMatch(lowerDescription);
            if (titleMatch != null) {
              title = titleMatch.group(2) ?? 'Новая цель';
            } else {
              title = 'Новая цель';
            }
          }
        }
        
        // Extract amount (look for numbers with various units)
        if (amount == null) {
          // Try different patterns for amount extraction
          final patterns = [
            // Millions
            RegExp(r'(\d+(?:\.\d+)?)\s*(млн|миллион|млн\.|млн\s)', caseSensitive: false),
            // Thousands
            RegExp(r'(\d+(?:\.\d+)?)\s*(тыс|тысяч|тыс\.|тыс\s|к)', caseSensitive: false),
            // Billions
            RegExp(r'(\d+(?:\.\d+)?)\s*(млрд|миллиард|млрд\.|млрд\s)', caseSensitive: false),
            // Simple numbers
            RegExp(r'(\d+(?:\.\d+)?)', caseSensitive: false),
          ];
          
          for (final pattern in patterns) {
            final match = pattern.firstMatch(lowerDescription);
            if (match != null) {
              final number = double.tryParse(match.group(1) ?? '');
              final unit = match.group(2)?.toLowerCase() ?? '';
              
              if (number != null) {
                if (unit.contains('млрд') || unit.contains('миллиард')) {
                  amount = number * 1000000000;
                } else if (unit.contains('млн') || unit.contains('миллион')) {
                  amount = number * 1000000;
                } else if (unit.contains('тыс') || unit.contains('тысяч') || unit.contains('к')) {
                  amount = number * 1000;
                } else {
                  amount = number;
                }
                break; // Found a match, stop looking
              }
            }
          }
        }
        
        // Extract deadline (look for various time expressions)
        if (deadlineText == null) {
          final timePatterns = [
            // Years
            RegExp(r'(\d+)\s*(года|лет|год|г\.)', caseSensitive: false),
            // Months
            RegExp(r'(\d+)\s*(месяца|месяцев|месяц|мес\.)', caseSensitive: false),
            // Days
            RegExp(r'(\d+)\s*(дня|дней|день|дн\.)', caseSensitive: false),
            // Weeks
            RegExp(r'(\d+)\s*(недели|недель|неделя|нед\.)', caseSensitive: false),
            // Half year
            RegExp(r'полгода|пол года', caseSensitive: false),
            // Quarter
            RegExp(r'квартал', caseSensitive: false),
          ];
          
          for (final pattern in timePatterns) {
            final match = pattern.firstMatch(lowerDescription);
            if (match != null) {
              if (pattern.pattern.contains('полгода')) {
                final deadline = DateTime.now().add(const Duration(days: 182));
                deadlineText = deadline.toIso8601String().split('T')[0];
                break;
              } else if (pattern.pattern.contains('квартал')) {
                final deadline = DateTime.now().add(const Duration(days: 91));
                deadlineText = deadline.toIso8601String().split('T')[0];
                break;
              } else {
                final number = int.tryParse(match.group(1) ?? '');
                if (number != null) {
                  DateTime deadline;
                  if (pattern.pattern.contains('года|лет|год')) {
                    deadline = DateTime.now().add(Duration(days: number * 365));
                  } else if (pattern.pattern.contains('месяца|месяцев|месяц')) {
                    deadline = DateTime.now().add(Duration(days: number * 30));
                  } else if (pattern.pattern.contains('недели|недель|неделя')) {
                    deadline = DateTime.now().add(Duration(days: number * 7));
                  } else if (pattern.pattern.contains('дня|дней|день')) {
                    deadline = DateTime.now().add(Duration(days: number));
                  } else {
                    continue;
                  }
                  deadlineText = deadline.toIso8601String().split('T')[0];
                  break;
                }
              }
            }
          }
        }
        
        print('Fallback parsing results - Title: $title, Amount: $amount, Deadline: $deadlineText');
      }
      
      print('Parsed - Title: $title, Amount: $amount, Deadline: $deadlineText');
      
      // Use defaults for missing information and validate
      final finalTitle = title.isNotEmpty ? title : 'Новая цель';
      final finalAmount = (amount != null && amount > 0) ? amount : 50000.0;
      final finalDeadlineText = (deadlineText != null && deadlineText.isNotEmpty) ? deadlineText : DateTime.now().add(const Duration(days: 365)).toIso8601String().split('T')[0];
      
      print('Final values - Title: $finalTitle, Amount: $finalAmount, Deadline: $finalDeadlineText');
      
      // Additional validation
      if (finalAmount <= 0) {
        throw Exception('Некорректная сумма цели: $finalAmount');
      }
      
      // Parse deadline - expect YYYY-MM-DD format from GPT
      DateTime deadline;
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(finalDeadlineText)) {
        // Parse YYYY-MM-DD format
        final parts = finalDeadlineText.split('-');
        final year = int.tryParse(parts[0]) ?? DateTime.now().year;
        final month = int.tryParse(parts[1]) ?? 1;
        final day = int.tryParse(parts[2]) ?? 1;
        deadline = DateTime(year, month, day);
      } else {
        // Fallback to current logic for other formats
        if (finalDeadlineText.contains('через') && finalDeadlineText.contains('год')) {
          final yearMatch = RegExp(r'через (\d+) год').firstMatch(finalDeadlineText);
          final years = int.tryParse(yearMatch?.group(1) ?? '1') ?? 1;
          deadline = DateTime.now().add(Duration(days: years * 365));
        } else if (finalDeadlineText.contains('через') && finalDeadlineText.contains('месяц')) {
          final monthMatch = RegExp(r'через (\d+) месяц').firstMatch(finalDeadlineText);
          final months = int.tryParse(monthMatch?.group(1) ?? '1') ?? 1;
          deadline = DateTime.now().add(Duration(days: months * 30));
        } else if (finalDeadlineText.contains('.')) {
          final parts = finalDeadlineText.split('.');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]) ?? 1;
            final month = int.tryParse(parts[1]) ?? 1;
            final year = int.tryParse(parts[2]) ?? DateTime.now().year;
            deadline = DateTime(year, month, day);
          } else {
            deadline = DateTime.now().add(const Duration(days: 365));
          }
        } else {
          deadline = DateTime.now().add(const Duration(days: 365));
        }
      }
      
      // Create the goal
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user != null) {
        await GoalService.createGoal(
          userId: user.id,
          title: finalTitle,
          amountTarget: finalAmount,
          deadlineDate: deadline,
        );
        
        setState(() {
          _messages.add(
            ChatMessage(
              text: "🎉 **Поздравляю! Новая цель создана!**\n\n📝 **Название**: $finalTitle\n💰 **Целевая сумма**: ${finalAmount.toStringAsFixed(0)} ₸\n📅 **Срок достижения**: ${deadline.day}.${deadline.month}.${deadline.year}\n\n✨ Отличная работа! Теперь вы можете отслеживать прогресс накоплений в разделе \"Цели\". Удачи в достижении вашей цели!",
              isUser: false,
              sender: "Zaman Assistant",
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "❌ **Ошибка при создании цели**: ${e.toString()}\n\nПопробуйте еще раз или обратитесь в поддержку.",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  bool _isTransferMessage(String message) {
    final lowerMessage = message.toLowerCase();
    final transferKeywords = [
      'send transfer',
      'transfer to',
      'отправить перевод',
      'перевод',
      'отправить',
      'send money',
      'отправить деньги',
    ];
    
    return transferKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  Future<void> _handleTransferCreation(String message) async {
    try {
      // Send a specific prompt to GPT to parse the transfer information
      final prompt = "Пользователь хочет сделать перевод: '$message'. Пожалуйста, извлеки информацию и ответь в следующем формате:\n\nRECIPIENT_NAME: [имя получателя]\nAMOUNT: [сумма в тенге, только число]\n\nЕсли какой-то информации не хватает, напиши 'НЕ УКАЗАНО' вместо этого поля.";
      
      final response = await ChatService.sendMessage(message: prompt);
      final responseText = response.response;
      
      // Parse the response
      final lines = responseText.split('\n');
      String? recipientName;
      double? amount;
      
      for (final line in lines) {
        if (line.startsWith('RECIPIENT_NAME:')) {
          recipientName = line.substring(15).trim();
        } else if (line.startsWith('AMOUNT:')) {
          final amountStr = line.substring(7).trim();
          if (amountStr != 'НЕ УКАЗАНО') {
            amount = double.tryParse(amountStr);
          }
        }
      }
      
      // Check if we have all required information
      if (recipientName == null || recipientName == 'НЕ УКАЗАНО' || amount == null) {
        // Ask for missing information
        String missingInfo = '';
        if (recipientName == null || recipientName == 'НЕ УКАЗАНО') missingInfo += 'имя получателя, ';
        if (amount == null) missingInfo += 'сумму, ';
        
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Для перевода мне нужна дополнительная информация. Пожалуйста, укажите: ${missingInfo.substring(0, missingInfo.length - 2)}.\n\nНапример: 'отправить перевод Джону 5000 тенге' или 'send transfer to John 5000'",
              isUser: false,
              sender: "Zaman Assistant",
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
        return;
      }
      
      // Search for recipient in backend
      await _searchAndConfirmTransfer(recipientName, amount);
      
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "❌ **Ошибка при обработке перевода**: ${e.toString()}\n\nПопробуйте еще раз или обратитесь в поддержку.",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _searchAndConfirmTransfer(String recipientName, double amount) async {
    try {
      print('ChatScreen: Searching for recipient: $recipientName');
      // Search for users by name
      final users = await UserService.searchUsersByName(recipientName);
      
      if (users.isEmpty) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "❌ **Получатель не найден**\n\nПользователь с именем '$recipientName' не найден в системе. Проверьте правильность написания имени.",
              isUser: false,
              sender: "Zaman Assistant",
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
        return;
      }
      
      if (users.length > 1) {
        // Multiple users found, show selection
        _showUserSelectionDialog(users, amount);
      } else {
        // Single user found, show confirmation
        final recipient = users.first;
        _showTransferConfirmation(recipient, amount);
      }
      
    } catch (e) {
      print('ChatScreen: Error searching for recipient: $e');
      String errorMessage = "❌ **Ошибка поиска получателя**";
      
      if (e.toString().contains('Network error')) {
        errorMessage += "\n\n🔌 **Проблема с подключением**\nПроверьте, что сервер запущен и доступен.";
      } else if (e.toString().contains('Failed to search users')) {
        errorMessage += "\n\n🔍 **Ошибка поиска**\nВозможно, сервер не отвечает или произошла ошибка на сервере.";
      } else {
        errorMessage += "\n\n${e.toString()}";
      }
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: errorMessage,
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _showUserSelectionDialog(List<User> users, double amount) {
    setState(() {
      _isTyping = false;
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите получателя'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.phoneNumber),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showTransferConfirmation(user, amount);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _showTransferConfirmation(User recipient, double amount) {
    setState(() {
      _isTyping = false;
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение перевода'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('**Получатель**: ${recipient.firstName} ${recipient.lastName}'),
              Text('**Телефон**: ${recipient.phoneNumber}'),
              Text('**Сумма**: ${amount.toStringAsFixed(0)} ₸'),
              const SizedBox(height: 16),
              const Text('Вы уверены, что хотите отправить этот перевод?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _executeTransfer(recipient.id, amount);
              },
              child: const Text('Подтвердить'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _executeTransfer(String recipientId, double amount) async {
    try {
      setState(() {
        _isTyping = true;
      });
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user != null) {
        await TransactionService.createTransaction(
          senderId: user.id,
          receiverId: recipientId,
          amount: amount,
          description: 'Transfer via chat',
          context: context,
        );
        
        setState(() {
          _messages.add(
            ChatMessage(
              text: "✅ **Перевод выполнен успешно!**\n\n💰 **Сумма**: ${amount.toStringAsFixed(0)} ₸\n📱 **Получатель**: $recipientId\n\nПеревод обработан и средства переведены.",
              isUser: false,
              sender: "Zaman Assistant",
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
      
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "❌ **Ошибка при выполнении перевода**: ${e.toString()}",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _addMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          sender: "Вы",
          timestamp: DateTime.now(),
        ),
      );
    });
    _messageController.clear();
    _scrollToBottom();
    
    // Add AI response after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Отличный выбор! Я помогу вам с этим. Расскажите подробнее о том, что вас интересует.",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }


  Future<void> _handleCategorySelection(String category) async {
    try {
      // Get category name for display
      final categoryNames = {
        'CLOSE_ONES': 'Близкие',
        'ENTERTAINMENT': 'Развлечения',
        'TRAVEL': 'Путешествия',
        'CLOTHES': 'Одежда',
        'FOOD': 'Еда',
        'CHARITY': 'Благотворительность',
        'EDUCATION': 'Образование',
        'BUSINESS': 'Бизнес',
        'OTHER': 'Другое',
      };

      final categoryName = categoryNames[category] ?? category;

      // Save to database
      await _saveTransactionIntention(categoryName, category);

      // Add confirmation message
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Спасибо! Категория '$categoryName' сохранена для этой транзакции.",
            isUser: false,
            sender: "Zaman Assistant",
            timestamp: DateTime.now(),
          ),
        );
        _isShowingCategorySelection = false;
      });

      _scrollToBottom();
    } catch (e) {
      print('Error handling category selection: $e');
      setState(() {
        _isShowingCategorySelection = false;
      });
    }
  }

  Future<void> _saveTransactionIntention(String userResponse, String category) async {
    try {
      final user = await AuthService.getCurrentUser();
      
      // Get the latest transaction by sendDate
      final latestTransaction = await TransactionService.getLatestTransactionByUserId(user.id);
      
      print('Saving transaction intention - TransactionId: ${latestTransaction?.id}, Category: $category, Response: $userResponse');
      
      if (latestTransaction != null) {
        final requestBody = {
          'transactionId': latestTransaction.id,
          'userId': user.id,
          'category': category,
          'type': 'NECESSARY',
          'userResponse': userResponse,
        };
        
        print('Request body: $requestBody');
        
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/transaction-intentions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await AuthService.getStoredToken()}',
          },
          body: jsonEncode(requestBody),
        );
        
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        if (response.statusCode == 200) {
          print('Transaction intention saved successfully');
        } else {
          print('Failed to save transaction intention: ${response.statusCode} - ${response.body}');
        }
      } else {
        print('No latest transaction found');
      }
    } catch (e) {
      print('Failed to save transaction intention: $e');
    }
  }

  Widget _buildCommandsButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.zamanPersianGreen,
            AppColors.zamanPersianGreen.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.zamanPersianGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.apps,
          color: AppColors.white,
          size: 22,
        ),
        onSelected: (String value) {
          if (value == 'goal_creation') {
            _messageController.text = 'goal: ';
            _messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: _messageController.text.length),
            );
          } else if (value == 'transfer') {
            _messageController.text = 'отправить перевод ';
            _messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: _messageController.text.length),
            );
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'goal_creation',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: AppColors.zamanPersianGreen),
                SizedBox(width: 8),
                Text('Создать цель'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'transfer',
            child: Row(
              children: [
                Icon(Icons.send_outlined, color: AppColors.zamanPersianGreen),
                SizedBox(width: 8),
                Text('Сделать перевод'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String sender;
  final DateTime timestamp;
  final bool isUnread;
  final bool isSystemMessage;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.sender,
    required this.timestamp,
    this.isUnread = false,
    this.isSystemMessage = false,
  });
}
