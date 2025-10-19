import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/transaction_card.dart';
import '../services/transaction_service.dart';
import '../services/auth_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  int _selectedIndex = 2;
  String _selectedTransactionType = 'All';
  String _selectedTimePeriod = 'Last Month';
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final user = await AuthService.getCurrentUser();
      final transactions = await TransactionService.getTransactionsByUserId(user.id);
      setState(() {
        _allTransactions = transactions;
        _currentUserId = user.id;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<Transaction> filtered = List.from(_allTransactions);
    
    // Apply transaction type filter
    if (_selectedTransactionType == 'Purchases') {
      filtered = filtered.where((transaction) => 
        _currentUserId != null && transaction.receiverId == _currentUserId).toList();
    } else if (_selectedTransactionType == 'Sales') {
      filtered = filtered.where((transaction) => 
        _currentUserId != null && transaction.senderId == _currentUserId).toList();
    }
    
    // Apply time period filter
    final now = DateTime.now();
    DateTime startDate;
    switch (_selectedTimePeriod) {
      case 'Last Month':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'Last Quarter':
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'Last Year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(2000); // Show all
    }
    
    filtered = filtered.where((transaction) => 
      transaction.sendDate.isAfter(startDate)).toList();
    
    // Sort by creation date in descending order (newest first)
    filtered.sort((a, b) => b.sendDate.compareTo(a.sendDate));
    
    setState(() {
      _filteredTransactions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Column(
              children: [
                // Transaction Type Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterChip('Все', _selectedTransactionType == 'All'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip('Покупки', _selectedTransactionType == 'Purchases'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip('Продажи', _selectedTransactionType == 'Sales'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Time Period Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeFilterChip('Последний месяц', _selectedTimePeriod == 'Last Month'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeFilterChip('Последний квартал', _selectedTimePeriod == 'Last Quarter'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTimeFilterChip('Последний год', _selectedTimePeriod == 'Last Year'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Transaction List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTransactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Нет транзакций',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _filteredTransactions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TransactionCard(
                              symbol: transaction.id,
                              companyName: transaction.description,
                              date: _formatDate(transaction.sendDate),
                              quantity: 1,
                              pricePerShare: transaction.amount,
                              totalAmount: transaction.amount,
                              isPurchase: _currentUserId != null ? transaction.receiverId == _currentUserId : false,
                            ),
                          );
                        },
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
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransactionType = label;
        });
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.teal : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimePeriod = label;
        });
        _applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E8) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.teal : AppColors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

