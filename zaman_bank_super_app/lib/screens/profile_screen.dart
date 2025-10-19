import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/navigation_utils.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';
import '../services/goal_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  double _balance = 0.0;
  int _transactionCount = 0;
  int _goalsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getCurrentUser();
      final transactions = await TransactionService.getTransactionsByUserId(user.id);
      final goals = await GoalService.getGoalsByUserId(user.id);
      
      setState(() {
        _balance = user.balance;
        _transactionCount = transactions.length;
        _goalsCount = goals.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading user data: $e');
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
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: const Text(
          'Профиль',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () {
              _loadUserData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.black),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main Profile Card
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
                      children: [
                        // Profile Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.zamanPersianGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // User Name
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              authProvider.user != null 
                                  ? '${authProvider.user!.firstName} ${authProvider.user!.lastName}'
                                  : 'Пользователь',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        
                        // User IIN
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              authProvider.user != null 
                                  ? 'ИИН: ${authProvider.user!.iin}'
                                  : 'ИИН: Не указан',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        // Phone Number
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Text(
                              authProvider.user != null 
                                  ? '${authProvider.user!.phoneNumber}'
                                  : '+7 777 000 0000',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Account Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.zamanSolar,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Активный аккаунт',
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                title: 'Баланс',
                                value: '₸${_balance.toStringAsFixed(0)}',
                                icon: Icons.account_balance_wallet_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatItem(
                                title: 'Транзакции',
                                value: '$_transactionCount',
                                icon: Icons.swap_horiz_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatItem(
                                title: 'Цели',
                                value: '$_goalsCount',
                                icon: Icons.flag_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                title: 'Изменить',
                                icon: Icons.edit_outlined,
                                onTap: () => _showEditProfileDialog(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                title: 'Настройки',
                                icon: Icons.settings_outlined,
                                onTap: () => _showSettingsDialog(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                title: 'Выйти',
                                icon: Icons.logout,
                                onTap: () => _showLogoutDialog(),
                                isDestructive: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Actions
                  Container(
                    width: double.infinity,
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
                          'Быстрые действия',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickAction(
                                title: 'История операций',
                                icon: Icons.history_outlined,
                                onTap: () => _showTransactionHistoryDialog(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickAction(
                                title: 'Мои цели',
                                icon: Icons.flag_outlined,
                                onTap: () => _showGoalsDialog(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickAction(
                                title: 'Поддержка',
                                icon: Icons.help_outline,
                                onTap: () => _showContactSupportDialog(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
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

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDestructive ? Colors.red : AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        border: isDestructive ? null : Border.all(color: AppColors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isDestructive ? AppColors.white : AppColors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDestructive ? AppColors.white : AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.zamanCloud,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.zamanPersianGreen.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.zamanPersianGreen,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Simplified dialog methods
  void _showSettingsDialog() {
    _showSimpleDialog('Настройки', 'Настройки приложения будут реализованы здесь.');
  }

  void _showEditProfileDialog() {
    _showSimpleDialog('Редактировать профиль', 'Функция редактирования профиля будет реализована здесь.');
  }

  void _showGoalsDialog() {
    _showSimpleDialog('Мои цели', 'У вас $_goalsCount активных целей. Перейдите в раздел "Цели" для управления.');
  }

  void _showTransactionHistoryDialog() {
    _showSimpleDialog('История операций', 'У вас $_transactionCount транзакций. Перейдите в раздел "История" для просмотра.');
  }

  void _showContactSupportDialog() {
    _showSimpleDialog('Связаться с поддержкой', 'Функция связи с поддержкой будет реализована здесь.');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Выйти из аккаунта',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Вы уверены, что хотите выйти из аккаунта?',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Выйти',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppColors.zamanPersianGreen,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}