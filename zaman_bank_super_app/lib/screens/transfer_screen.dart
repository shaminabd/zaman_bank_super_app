import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/loading_widget.dart';
import '../utils/navigation_utils.dart';
import '../services/transaction_service.dart';
import '../services/auth_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 1;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  double _currentBalance = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final user = await AuthService.getCurrentUser();
      setState(() {
        _currentBalance = user.balance;
      });
    } catch (e) {
      setState(() {
        _currentBalance = 0.0; // Reset to 0 if API fails
      });
      print('Error loading balance: $e');
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: AppColors.zamanCloud,
      appBar: AppBar(
        backgroundColor: AppColors.zamanCloud,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: const Text(
          'Переводы',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.zamanPersianGreen,
                    AppColors.zamanPersianGreen.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zamanPersianGreen.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Текущий баланс',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '₸ ${_currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Доступно для переводов',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Transfer Amount Input
            const Text(
              'Сумма перевода',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Введите сумму',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                  ),
                  prefixText: '₸ ',
                  prefixStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Phone Number Input
            const Text(
              'Номер телефона получателя',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              child: TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: '+7 777 123 4567',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
                // Transfer Button
                SmoothButton(
                  onPressed: _isLoading ? null : () {
                    _showTransferConfirmation();
                  },
                  backgroundColor: AppColors.zamanPersianGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const LoadingWidget(
                            size: 20,
                            color: AppColors.white,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Перевести',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
          ],
        ),
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

  void _showTransferConfirmation() {
    final amount = _amountController.text;
    final phone = _phoneNumberController.text;
    
    if (amount.isEmpty || phone.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля', isError: true);
      return;
    }
    
    final transferAmount = double.tryParse(amount);
    if (transferAmount == null || transferAmount <= 0) {
      _showSnackBar('Введите корректную сумму', isError: true);
      return;
    }
    
    if (transferAmount > _currentBalance) {
      _showSnackBar('Недостаточно средств на счете', isError: true);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Подтверждение перевода',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.zamanCloud,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Сумма:',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₸$amount',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Получатель:',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        phone,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Вы уверены, что хотите выполнить этот перевод?',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
              ),
            ),
          ),
          SmoothButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performTransfer();
            },
            backgroundColor: AppColors.zamanPersianGreen,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: BorderRadius.circular(8),
            child: const Text(
              'Подтвердить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performTransfer() async {
    final amount = _amountController.text;
    final phoneNumber = _phoneNumberController.text;
    
    if (amount.isEmpty || phoneNumber.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля', isError: true);
      return;
    }
    
    final transferAmount = double.tryParse(amount);
    if (transferAmount == null || transferAmount <= 0) {
      _showSnackBar('Введите корректную сумму', isError: true);
      return;
    }

    if (transferAmount > _currentBalance) {
      _showSnackBar('Недостаточно средств', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService.getCurrentUser();
      
      // Find receiver by phone number
      final receiver = await AuthService.getUserByPhoneNumber(phoneNumber);
      
      await TransactionService.createTransaction(
        senderId: user.id,
        receiverId: receiver.id,
        amount: transferAmount,
        description: 'Перевод на номер $phoneNumber',
        context: context,
      );
      
      _showSnackBar('Перевод выполнен успешно!', isError: false);
      _amountController.clear();
      _phoneNumberController.clear();
      
      // Reload balance
      await _loadBalance();
    } catch (e) {
      _showSnackBar('Ошибка при выполнении перевода: ${e.toString()}', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppColors.zamanPersianGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
