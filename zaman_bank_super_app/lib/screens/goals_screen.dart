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
                    predefinedText: "Я хочу создать цель (название цели) до (дедлайн) откладывая (N-ую сумму или же мы сами выясним с помощью умного расчета)",
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
                predefinedText: "Я хочу создать цель (название цели) до (дедлайн) откладывая (N-ую сумму или же мы сами выясним с помощью умного расчета)",
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
            child: const Icon(
              Icons.flag_outlined,
              size: 60,
              color: AppColors.zamanPersianGreen,
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
                    predefinedText: "Я хочу создать цель (название цели) до (дедлайн) откладывая (N-ую сумму или же мы сами выясним с помощью умного расчета)",
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
        ],
      ),
    );
  }
}

