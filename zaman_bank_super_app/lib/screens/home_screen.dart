import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/promo_card.dart';
import '../widgets/account_card.dart';
import '../widgets/action_button.dart';
import '../widgets/finance_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/brokerage_button.dart';
import '../utils/page_transitions.dart';
import '../services/auth_service.dart';
import 'top_up_screen.dart';
import 'transfer_screen.dart';
import 'broker_account_screen.dart';
import 'goals_screen.dart';
import 'transactions_screen.dart';
import 'financial_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double _balance = 0.0;
  bool _isLoadingBalance = true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final user = await AuthService.getCurrentUser();
      setState(() {
        _balance = user.balance;
        _isLoadingBalance = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBalance = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мой банк',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.person_outline, color: AppColors.black),
          ),
        ],
      ),
      backgroundColor: AppColors.zamanCloud,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Promotional cards
            SizedBox(
              height: 200,
              child: PageView(
                children: const [
                  PromoCard(
                    title: 'Средства на ваши цели',
                    subtitle: 'Быстрое оформление онлайн по исламским принципам',
                    details: 'до 3 млн ₸, до 5 лет',
                    gradient: LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
                    ),
                  ),
                  PromoCard(
                    title: 'Исламское накопление',
                    subtitle: 'Сбережения по исламским принципам',
                    details: 'доход от 50%',
                    gradient: LinearGradient(
                      colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cards and accounts section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Карты и счета',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_up, color: AppColors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AccountCard(
                    balance: _balance,
                    isLoading: _isLoadingBalance,
                  ),
                  const SizedBox(height: 24),
                  
                // Action buttons - First row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.add,
                      label: 'Пополнить',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransitions.slideFromRight(
                            page: const TopUpScreen(),
                          ),
                        );
                      },
                    ),
                    ActionButton(
                      icon: Icons.swap_horiz,
                      label: 'Перевести',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransitions.slideFromRight(
                            page: const TransferScreen(),
                          ),
                        );
                      },
                    ),
                    ActionButton(
                      icon: Icons.receipt_long,
                      label: 'История',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransitions.slideFromRight(
                            page: const TransactionsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action buttons - Second row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.analytics_outlined,
                      label: 'Анализ',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransitions.slideFromRight(
                            page: const FinancialAnalysisScreen(),
                          ),
                        );
                      },
                    ),
                    BrokerageButton(
                      icon: Icons.trending_up,
                      label: 'Брокерский счет',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransitions.slideFromRight(
                            page: const BrokerAccountScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Financing section
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Финансирование',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_up, color: AppColors.grey),
                          SizedBox(width: 8),
                          Icon(Icons.add, color: AppColors.teal),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const FinanceCard(),
                  const SizedBox(height: 24),
                  
                  // Goals section
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Мои цели',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_up, color: AppColors.grey),
                          SizedBox(width: 8),
                          Icon(Icons.add, color: AppColors.teal),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransitions.slideFromRight(
                          page: const GoalsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Цели накопления',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Создавайте и отслеживайте цели',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Управлять',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.zamanPersianGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.zamanPersianGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flag_outlined,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Savings section
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Накопления',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_up, color: AppColors.grey),
                          SizedBox(width: 8),
                          Icon(Icons.add, color: AppColors.teal),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Исламские накопления',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'до 50% годовых',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Открыть',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.zamanPersianGreen,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.zamanPersianGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.savings,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100), // Space for bottom navigation
                ],
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
}
