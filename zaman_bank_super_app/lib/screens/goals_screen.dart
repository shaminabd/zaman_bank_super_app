import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../utils/page_transitions.dart';
import 'chat_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user != null) {
        final goals = await GoalService.getGoalsByUserId(user.id);
        setState(() {
          _goals = goals;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Мои цели',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.zamanPersianGreen),
            onPressed: () {
              // Navigate to chat for goal creation with predefined text
              Navigator.of(context).push(
                PageTransitions.slideFromRight(
                  page: const ChatScreen(
                    predefinedText: "goal: ",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _goals.isEmpty
              ? _buildEmptyState()
              : _buildGoalsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageTransitions.slideFromRight(
              page: const ChatScreen(
                predefinedText: "goal: ",
              ),
            ),
          );
        },
        backgroundColor: AppColors.zamanPersianGreen,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.zamanPersianGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'images/image.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.flag_outlined,
                    size: 60,
                    color: AppColors.zamanPersianGreen,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'У вас пока нет целей',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Создайте свою первую цель накопления',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                PageTransitions.slideFromRight(
                  page: const ChatScreen(
                    predefinedText: "goal: ",
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Создать цель'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zamanPersianGreen,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList() {
    return RefreshIndicator(
      onRefresh: _loadGoals,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          final goal = _goals[index];
          return _buildGoalCard(goal);
        },
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final progress = goal.amountSaved / goal.amountTarget;
    final daysLeft = goal.deadlineDate.difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: daysLeft > 30 
                      ? AppColors.zamanPersianGreen.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeft > 0 ? '$daysLeft дн.' : 'Просрочено',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: daysLeft > 30 
                        ? AppColors.zamanPersianGreen
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${goal.amountSaved.toStringAsFixed(0)} ₸',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                'из ${goal.amountTarget.toStringAsFixed(0)} ₸',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.zamanCloud,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.zamanPersianGreen : AppColors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% выполнено',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'До ${goal.deadlineDate.day}.${goal.deadlineDate.month}.${goal.deadlineDate.year}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              if (goal.moneyAmount > 0)
                Text(
                  'Рекомендуется: ${goal.moneyAmount.toStringAsFixed(0)} ₸',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.zamanPersianGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _editGoal(goal),
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.zamanPersianGreen,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => _deleteGoal(goal),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editGoal(Goal goal) {
    final TextEditingController titleController = TextEditingController(text: goal.title);
    DateTime selectedDate = goal.deadlineDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Редактировать цель',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Название цели',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Отмена',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введите название цели')),
                );
                return;
              }
              
              try {
                await GoalService.updateGoal(
                  goalId: goal.id,
                  title: titleController.text.trim(),
                  amountTarget: goal.amountTarget,
                  deadlineDate: selectedDate,
                );
                
                Navigator.of(context).pop();
                _loadGoals();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Цель успешно обновлена!'),
                    backgroundColor: AppColors.zamanPersianGreen,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка при обновлении цели: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zamanPersianGreen,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Удалить цель',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Вы уверены, что хотите удалить цель "${goal.title}"? Это действие нельзя отменить.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Отмена',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await GoalService.deleteGoal(goal.id);
                
                Navigator.of(context).pop();
                _loadGoals();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Цель успешно удалена!'),
                    backgroundColor: AppColors.zamanPersianGreen,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка при удалении цели: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

