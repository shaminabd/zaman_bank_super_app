import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../services/transaction_service.dart';
import '../services/auth_service.dart';
import '../widgets/bottom_navigation.dart';

class FinancialAnalysisScreen extends StatefulWidget {
  const FinancialAnalysisScreen({super.key});

  @override
  State<FinancialAnalysisScreen> createState() => _FinancialAnalysisScreenState();
}

class _FinancialAnalysisScreenState extends State<FinancialAnalysisScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisData;
  String? _aiAdvice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zamanCloud,
      appBar: AppBar(
        title: const Text(
          'Анализ доходов и расходов',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.zamanPersianGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildAnalyzeButton(),
            const SizedBox(height: 24),
            if (_analysisData != null) ...[
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildPieChart(),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(),
              const SizedBox(height: 24),
              _buildAIAdvice(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
        onItemTapped: (index) {
          // Handle navigation if needed
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Выберите период анализа',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  'Начальная дата',
                  _startDate,
                  (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  'Конечная дата',
                  _endDate,
                  (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              onChanged(selectedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.zamanCloud,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.zamanPersianGreen.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.zamanPersianGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd.MM.yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isAnalyzing ? null : _analyzeTransactions,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.zamanPersianGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isAnalyzing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Анализировать',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalIncome = _analysisData!['totalIncome'] as double;
    final totalExpenses = _analysisData!['totalExpenses'] as double;
    final netIncome = totalIncome - totalExpenses;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Доходы',
            totalIncome,
            Colors.green,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Расходы',
            totalExpenses,
            Colors.red,
            Icons.trending_down,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Баланс',
            netIncome,
            netIncome >= 0 ? Colors.blue : Colors.orange,
            Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(0)} ₸',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final totalIncome = _analysisData!['totalIncome'] as double;
    final totalExpenses = _analysisData!['totalExpenses'] as double;
    final total = totalIncome + totalExpenses;

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Нет данных для отображения',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Доходы и расходы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: totalIncome,
                    title: 'Доходы',
                    color: Colors.green,
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: totalExpenses,
                    title: 'Расходы',
                    color: Colors.red,
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final categories = _analysisData!['categories'] as Map<String, double>;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Расходы по категориям',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...categories.entries.map((entry) {
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
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryNames[entry.key] ?? entry.key,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    '${entry.value.toStringAsFixed(0)} ₸',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAIAdvice() {
    if (_aiAdvice == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.zamanPersianGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Персональные рекомендации',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _aiAdvice!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeTransactions() async {
    setState(() => _isAnalyzing = true);

    try {
      final user = await AuthService.getCurrentUser();
      final transactions = await TransactionService.getTransactionsByUserId(user.id.toString());
      
      // Filter transactions by date range
      final filteredTransactions = transactions.where((transaction) {
        return transaction.sendDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
               transaction.sendDate.isBefore(_endDate.add(const Duration(days: 1)));
      }).toList();

      // Calculate analysis
      double totalIncome = 0;
      double totalExpenses = 0;
      Map<String, double> categories = {};

      for (final transaction in filteredTransactions) {
        print('Transaction: ${transaction.id}');
        print('Sender: ${transaction.senderId}');
        print('Receiver: ${transaction.receiverId}');
        print('User ID: ${user.id}');
        print('Amount: ${transaction.amount}');
        
        if (transaction.senderId == user.id) {
          // I sent money to someone - this is an expense
          print('EXPENSE: I sent ${transaction.amount} to someone');
          totalExpenses += transaction.amount;
          
          // Get intention for this transaction
          try {
            final intention = await _getTransactionIntention(transaction.id);
            if (intention != null) {
              final category = intention['category'] as String;
              categories[category] = (categories[category] ?? 0) + transaction.amount;
            }
          } catch (e) {
            print('Error fetching intention for transaction ${transaction.id}: $e');
          }
        } else {
          // Someone sent money to me - this is income
          print('INCOME: Someone sent me ${transaction.amount}');
          totalIncome += transaction.amount;
        }
      }
      
      print('Total Income: $totalIncome');
      print('Total Expenses: $totalExpenses');

      // Get AI advice
      final aiAdvice = await _getAIAdvice(totalIncome, totalExpenses, categories);

      setState(() {
        _analysisData = {
          'totalIncome': totalIncome,
          'totalExpenses': totalExpenses,
          'categories': categories,
        };
        _aiAdvice = aiAdvice;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка анализа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _getTransactionIntention(String transactionId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/transaction-intentions/transaction/$transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService.getStoredToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        return null; // No intention found
      } else {
        print('Failed to fetch intention: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching intention: $e');
      return null;
    }
  }

  Future<String> _getAIAdvice(double income, double expenses, Map<String, double> categories) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer sk-proj-qqVgWBEmX8WuB7lO0-8fJi3DsSB2LFkaq5NXWHYw2VpdVOYx0IA',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': '''
Проанализируй финансовые данные клиента и дай персональные рекомендации:

Доходы: ${income.toStringAsFixed(0)} ₸
Расходы: ${expenses.toStringAsFixed(0)} ₸
Баланс: ${(income - expenses).toStringAsFixed(0)} ₸

Период: ${DateFormat('dd.MM.yyyy').format(_startDate)} - ${DateFormat('dd.MM.yyyy').format(_endDate)}

Расходы по категориям:
${categories.entries.map((e) {
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
  return '- ${categoryNames[e.key] ?? e.key}: ${e.value.toStringAsFixed(0)} ₸';
}).join('\n')}

Дай конкретные советы по:
1. Оптимизации расходов по категориям
2. Увеличению сбережений
3. Финансовому планированию
4. Исламским принципам управления финансами

Отвечай на русском языке, кратко и по делу.
              '''
            }
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Не удалось получить рекомендации. Попробуйте позже.';
      }
    } catch (e) {
      return 'Ошибка получения рекомендаций: $e';
    }
  }
}
