import '../services/goal_service.dart';

class FunctionCallHandler {
  static bool shouldTriggerGoalCreation(String message) {
    final lowerMessage = message.toLowerCase();
    final goalKeywords = [
      'goal:',
      'goal',
      'создать цель',
      'добавить цель',
      'новая цель',
      'хочу накопить',
      'накопить на',
      'цель накопления',
      'сбережения',
      'создать план',
      'финансовая цель',
      'цель по деньгам',
      'поставить цель',
      'установить цель',
      'хочу поставить',
      'хочу установить',
      'цель на',
      'накопления на',
      'сбережения на',
      'планирую накопить',
      'хочу собрать',
      'собрать на',
      'create goal',
      'add goal',
      'new goal',
      'save money',
      'financial goal',
      'set goal',
      'establish goal',
    ];
    
    return goalKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  static String categorizeTransaction(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('необходимая') || lowerMessage.contains('необходимые') || 
        lowerMessage.contains('еда') || lowerMessage.contains('продукты') ||
        lowerMessage.contains('лекарства') || lowerMessage.contains('медицина') ||
        lowerMessage.contains('коммунальные') || lowerMessage.contains('услуги')) {
      return 'Необходимая';
    } else if (lowerMessage.contains('покупки') || lowerMessage.contains('покупка') ||
               lowerMessage.contains('одежда') || lowerMessage.contains('обувь') ||
               lowerMessage.contains('техника') || lowerMessage.contains('электроника')) {
      return 'Покупки';
    } else if (lowerMessage.contains('спонтанная') || lowerMessage.contains('спонтанные') ||
               lowerMessage.contains('развлечения') || lowerMessage.contains('отдых') ||
               lowerMessage.contains('досуг')) {
      return 'Спонтанная';
    } else {
      return 'Другое';
    }
  }

  static String generateCategorizationResponse(String category) {
    switch (category) {
      case 'Необходимая':
        return '✅ Отлично! Вы правильно классифицировали эту транзакцию как необходимую. Такие расходы важны для поддержания вашего образа жизни и здоровья. Продолжайте следить за своими финансами!';
      case 'Покупки':
        return '🛍️ Понятно! Эта транзакция была связана с покупками. Помните, что важно планировать такие расходы заранее и не превышать свой бюджет.';
      case 'Спонтанная':
        return '💫 Спасибо за честность! Спонтанные покупки - это нормально, но старайтесь их контролировать. Возможно, стоит создать резервный фонд для таких случаев.';
      case 'Другое':
        return '📝 Спасибо за категоризацию! Ваша информация поможет нам лучше понимать ваши финансовые привычки и давать более точные рекомендации.';
      default:
        return 'Спасибо за категоризацию транзакции! Это поможет нам лучше понимать ваши финансовые привычки.';
    }
  }

  static Map<String, dynamic>? extractGoalInfo(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Extract amount
    final amountRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:₸|тенге|тысяч|млн|миллион)');
    final amountMatch = amountRegex.firstMatch(message);
    double? amount;
    if (amountMatch != null) {
      amount = double.tryParse(amountMatch.group(1) ?? '');
      if (lowerMessage.contains('млн') || lowerMessage.contains('миллион')) {
        amount = amount != null ? amount * 1000000 : null;
      } else if (lowerMessage.contains('тысяч')) {
        amount = amount != null ? amount * 1000 : null;
      }
    }

    // Extract title/description
    String? title;
    if (lowerMessage.contains('накопить на')) {
      final titleMatch = RegExp(r'накопить на (.+?)(?:\s+\d|$)').firstMatch(message);
      title = titleMatch?.group(1)?.trim();
    } else if (lowerMessage.contains('создать цель')) {
      final titleMatch = RegExp(r'создать цель (.+?)(?:\s+до|\s+\d|$)').firstMatch(message);
      title = titleMatch?.group(1)?.trim();
    } else if (lowerMessage.contains('цель')) {
      final titleMatch = RegExp(r'цель[:\s]*(.+?)(?:\s+\d|$)').firstMatch(message);
      title = titleMatch?.group(1)?.trim();
    } else if (lowerMessage.contains('на')) {
      final titleMatch = RegExp(r'на (.+?)(?:\s+\d|$)').firstMatch(message);
      title = titleMatch?.group(1)?.trim();
    }

    // Extract deadline
    String? deadline;
    bool hasDeadline = false;
    
    // Check for specific date patterns
    final dateRegex = RegExp(r'(\d{1,2})[./](\d{1,2})[./](\d{4})');
    final dateMatch = dateRegex.firstMatch(message);
    if (dateMatch != null) {
      deadline = '${dateMatch.group(1)}.${dateMatch.group(2)}.${dateMatch.group(3)}';
      hasDeadline = true;
    }
    
    // Check for Russian date patterns like "30го января", "до 30го января"
    if (!hasDeadline) {
      final russianDateRegex = RegExp(r'(\d{1,2})го\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)');
      final russianDateMatch = russianDateRegex.firstMatch(message);
      if (russianDateMatch != null) {
        final day = russianDateMatch.group(1)!;
        final monthName = russianDateMatch.group(2)!;
        
        // Convert month name to number
        final monthMap = {
          'января': '01', 'февраля': '02', 'марта': '03', 'апреля': '04',
          'мая': '05', 'июня': '06', 'июля': '07', 'августа': '08',
          'сентября': '09', 'октября': '10', 'ноября': '11', 'декабря': '12'
        };
        
        final monthNumber = monthMap[monthName];
        if (monthNumber != null) {
          final currentYear = DateTime.now().year;
          deadline = '$day.$monthNumber.$currentYear';
          hasDeadline = true;
        }
      }
    }
    
    // Check for relative time patterns
    if (!hasDeadline) {
      if (lowerMessage.contains('через') && lowerMessage.contains('месяц')) {
        final monthMatch = RegExp(r'через (\d+) месяц').firstMatch(message);
        if (monthMatch != null) {
          final months = int.tryParse(monthMatch.group(1) ?? '') ?? 1;
          deadline = 'через $months месяц(а)';
          hasDeadline = true;
        }
      } else if (lowerMessage.contains('через') && lowerMessage.contains('год')) {
        final yearMatch = RegExp(r'через (\d+) год').firstMatch(message);
        if (yearMatch != null) {
          final years = int.tryParse(yearMatch.group(1) ?? '') ?? 1;
          deadline = 'через $years год(а)';
          hasDeadline = true;
        }
      } else if (lowerMessage.contains('к концу года')) {
        deadline = 'к концу года';
        hasDeadline = true;
      } else if (lowerMessage.contains('к началу года')) {
        deadline = 'к началу года';
        hasDeadline = true;
      }
    }

    return {
      'amount': amount,
      'title': title,
      'deadline': deadline,
      'hasAmount': amount != null,
      'hasTitle': title != null,
      'hasDeadline': hasDeadline,
    };
  }

  static String generateGoalResponse(String message, Map<String, dynamic> goalInfo) {
    final hasAmount = goalInfo['hasAmount'] as bool;
    final hasTitle = goalInfo['hasTitle'] as bool;
    final hasDeadline = goalInfo['hasDeadline'] as bool? ?? false;
    final amount = goalInfo['amount'] as double?;
    final title = goalInfo['title'] as String?;
    final deadline = goalInfo['deadline'] as String?;

    if (hasAmount && hasTitle && hasDeadline) {
      return "Отлично! Я создам цель накопления:\n\n📝 **Название**: $title\n💰 **Сумма**: ${amount!.toStringAsFixed(0)} ₸\n📅 **Срок**: $deadline\n\nСоздать эту цель? (Да/Нет)";
    } else if (hasAmount && hasTitle && !hasDeadline) {
      return "Понял! Вы хотите накопить ${amount!.toStringAsFixed(0)} ₸ на $title. Когда вы планируете достичь этой цели? (например: через 6 месяцев, к концу года, к 1 января 2025)";
    } else if (hasAmount && !hasTitle) {
      return "Понял! Вы хотите накопить ${amount!.toStringAsFixed(0)} ₸. На что именно вы хотите накопить? (например: машина, отпуск, квартира)";
    } else if (!hasAmount && hasTitle) {
      return "Понял! Вы хотите накопить на $title. Какую сумму вы планируете накопить? (в тенге)";
    } else {
      return "Отлично! Давайте создадим цель накопления. На что вы хотите накопить и какую сумму планируете собрать?";
    }
  }

  static bool isGoalConfirmation(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('да') || 
           lowerMessage.contains('yes') || 
           lowerMessage.contains('создать') ||
           lowerMessage.contains('подтверждаю');
  }

  static Future<String> createGoalFromChat(String userId, Map<String, dynamic> goalInfo) async {
    try {
      // Auto-fill missing information with smart defaults
      final amount = goalInfo['amount'] as double? ?? 1000000.0;
      final title = goalInfo['title'] as String? ?? 'Новая цель';
      final deadlineText = goalInfo['deadline'] as String? ?? 'через 1 год';
      
      // Parse deadline
      DateTime deadline;
      if (deadlineText.contains('через') && deadlineText.contains('месяц')) {
        final monthMatch = RegExp(r'через (\d+) месяц').firstMatch(deadlineText);
        final months = int.tryParse(monthMatch?.group(1) ?? '1') ?? 1;
        deadline = DateTime.now().add(Duration(days: months * 30));
      } else if (deadlineText.contains('через') && deadlineText.contains('год')) {
        final yearMatch = RegExp(r'через (\d+) год').firstMatch(deadlineText);
        final years = int.tryParse(yearMatch?.group(1) ?? '1') ?? 1;
        deadline = DateTime.now().add(Duration(days: years * 365));
      } else if (deadlineText.contains('к концу года')) {
        deadline = DateTime(DateTime.now().year, 12, 31);
      } else if (deadlineText.contains('к началу года')) {
        deadline = DateTime(DateTime.now().year + 1, 1, 1);
      } else if (deadlineText.contains('.')) {
        // Handle DD.MM.YYYY format
        final parts = deadlineText.split('.');
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

      // Get user balance for money allocation
      final balance = await _getUserBalance(userId);
      final moneyAmount = _calculateMoneyAmount(balance, amount);

      await GoalService.createGoal(
        userId: userId,
        title: title,
        amountTarget: amount,
        deadlineDate: deadline,
      );

      return "🎉 **Поздравляю! Новая цель создана!**\n\n📝 **Название**: $title\n💰 **Целевая сумма**: ${amount.toStringAsFixed(0)} ₸\n📅 **Срок достижения**: ${deadline.day}.${deadline.month}.${deadline.year}\n💵 **Рекомендуемый ежемесячный взнос**: ${moneyAmount.toStringAsFixed(0)} ₸\n\n✨ Отличная работа! Теперь вы можете отслеживать прогресс накоплений в разделе \"Цели\". Удачи в достижении вашей цели!";
    } catch (e) {
      return "❌ **Ошибка при создании цели**: ${e.toString()}\n\nПопробуйте еще раз или обратитесь в поддержку.";
    }
  }

  static Future<double> _getUserBalance(String userId) async {
    try {
      return await GoalService.getUserBalance(userId);
    } catch (e) {
      return 0.0;
    }
  }

  static double _calculateMoneyAmount(double balance, double targetAmount) {
    if (balance <= 0) return 0.0;
    
    // Calculate 10-20% of balance as recommended amount
    final percentage = 0.15; // 15% of current balance
    final recommendedAmount = balance * percentage;
    
    // Don't exceed 50% of target amount
    final maxAmount = targetAmount * 0.5;
    
    return recommendedAmount > maxAmount ? maxAmount : recommendedAmount;
  }
}
