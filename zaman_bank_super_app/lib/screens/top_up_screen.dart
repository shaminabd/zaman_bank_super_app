import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/balance_service.dart';
import '../providers/auth_provider.dart';
import '../utils/page_transitions.dart';
import '../utils/navigation_utils.dart';
import '../widgets/loading_widget.dart';
import 'transfer_screen.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  String _selectedPaymentMethod = 'Bank Card';
  bool _isLoading = false;
  
  // Mock balance - in real app this would come from API
  final double _currentBalance = 125000.50;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Bank Card',
      'icon': Icons.credit_card_outlined,
      'description': 'Пополнение с банковской карты',
    },
    {
      'name': 'Bank Transfer',
      'icon': Icons.account_balance_outlined,
      'description': 'Банковский перевод',
    },
    {
      'name': 'E-wallets',
      'icon': Icons.account_balance_wallet_outlined,
      'description': 'Электронные кошельки',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _securityCodeController.dispose();
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
        title: const Text(
          'Пополнить счет',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
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
                    'Доступно для использования',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Method Selection
            const Text(
              'Способ пополнения',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)).toList(),

            const SizedBox(height: 24),

            // Amount Input
            const Text(
              'Сумма пополнения',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Введите сумму',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 18,
                  ),
                  prefixText: '₸ ',
                  prefixStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Security Code Input
            const Text(
              'Код безопасности',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              child: TextField(
                controller: _securityCodeController,
                keyboardType: TextInputType.number,
                obscureText: true,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Введите код безопасности',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Transfer Button
            SmoothButton(
              onPressed: _isLoading ? null : () {
                Navigator.of(context).push(
                  PageTransitions.slideFromRight(
                    page: const TransferScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.zamanSolar,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_horiz, size: 20),
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

            const SizedBox(height: 16),

            // Top Up Button
            SmoothButton(
              onPressed: _isLoading ? null : () {
                _performTopUp();
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
                          const Icon(Icons.add, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Пополнить',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['name'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPaymentMethod = method['name'];
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppColors.zamanPersianGreen 
                    : AppColors.zamanPersianGreen.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.zamanPersianGreen 
                        : AppColors.zamanPersianGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    method['icon'],
                    color: isSelected ? AppColors.white : AppColors.zamanPersianGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['name'],
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['description'],
                        style: TextStyle(
                          color: AppColors.grey.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.zamanPersianGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _performTopUp() async {
    final amount = _amountController.text;
    final securityCode = _securityCodeController.text;
    
    if (amount.isEmpty || securityCode.isEmpty) {
      _showSnackBar('Пожалуйста, заполните все поля', isError: true);
      return;
    }
    
    final topUpAmount = double.tryParse(amount);
    if (topUpAmount == null || topUpAmount <= 0) {
      _showSnackBar('Введите корректную сумму', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = AuthProvider();
      final user = authProvider.user;
      if (user != null) {
        await BalanceService.addBalance(user.id, topUpAmount);
        _showSnackBar('Счет успешно пополнен на ₸$amount!', isError: false);
        
        _amountController.clear();
        _securityCodeController.clear();
      } else {
        _showSnackBar('Пользователь не найден', isError: true);
      }
    } catch (e) {
      _showSnackBar('Ошибка при пополнении счета: ${e.toString()}', isError: true);
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