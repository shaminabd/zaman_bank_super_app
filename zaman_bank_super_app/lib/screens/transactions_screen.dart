import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/transaction_service.dart';
import '../services/auth_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = await AuthService.getCurrentUser();
      final transactions = await TransactionService.getTransactionsByUserId(user.id);
      // Sort transactions by creation date in descending order (newest first)
      transactions.sort((a, b) => b.sendDate.compareTo(a.sendDate));
      
      setState(() {
        _transactions = transactions;
        _currentUserId = user.id;
      });
    } catch (e) {
      _showSnackBar('Ошибка загрузки транзакций: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.zamanPersianGreen,
        duration: const Duration(seconds: 3),
      ),
    );
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
          'История транзакций',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.zamanPersianGreen),
            onPressed: _loadTransactions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? _buildEmptyState()
              : _buildTransactionsList(),
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
              Icons.receipt_long_outlined,
              size: 60,
              color: AppColors.zamanPersianGreen,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Нет транзакций',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ваши транзакции появятся здесь',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = _currentUserId != null && transaction.receiverId == _currentUserId;
    final amount = transaction.amount;
    final isPositive = isIncome;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPositive 
                  ? AppColors.zamanPersianGreen.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: isPositive ? AppColors.zamanPersianGreen : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description.isNotEmpty 
                      ? transaction.description 
                      : (isIncome ? 'Поступление' : 'Перевод'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.sendDate),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${transaction.id.substring(0, 8)}...',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${amount.toStringAsFixed(0)} ₸',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? AppColors.zamanPersianGreen : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: transaction.isHalal 
                      ? AppColors.zamanPersianGreen.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transaction.isHalal ? 'Халяль' : 'Не халяль',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: transaction.isHalal 
                        ? AppColors.zamanPersianGreen 
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
