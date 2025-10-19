import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_navigation.dart';
import '../utils/navigation_utils.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

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
            icon: const Icon(Icons.settings_outlined, color: AppColors.black),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Card
            Container(
              margin: const EdgeInsets.all(16),
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
                            : 'Ахмед Касымов',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  
                  // User ID
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Text(
                        authProvider.user != null 
                            ? 'ID: ${authProvider.user!.iin}'
                            : 'ID: 123456789',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  
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
                ],
              ),
            ),

            // Quick Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Баланс',
                      value: '₸125,000',
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppColors.zamanPersianGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Карты',
                      value: '2',
                      icon: Icons.credit_card_outlined,
                      color: AppColors.zamanSolar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Переводы',
                      value: '15',
                      icon: Icons.swap_horiz_outlined,
                      color: AppColors.zamanPersianGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Sections
            _buildMenuSection(
              title: 'Личные данные',
              items: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Редактировать профиль',
                  subtitle: 'Имя, фамилия, контакты',
                  onTap: () => _showEditProfileDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'ahmed.kasymov@email.com',
                  onTap: () => _showContactDialog('Email'),
                ),
                _buildMenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Телефон',
                  subtitle: '+7 777 123 4567',
                  onTap: () => _showContactDialog('Phone'),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'Безопасность',
              items: [
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Изменить пароль',
                  subtitle: 'Обновить пароль для безопасности',
                  onTap: () => _showChangePasswordDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.fingerprint_outlined,
                  title: 'Биометрия',
                  subtitle: 'Вход по отпечатку пальца',
                  onTap: () => _showBiometryDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  title: 'Двухфакторная аутентификация',
                  subtitle: 'Дополнительная защита',
                  onTap: () => _showTwoFactorDialog(),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'Банковские услуги',
              items: [
                _buildMenuItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Банковские реквизиты',
                  subtitle: 'Просмотр и управление',
                  onTap: () => _showBankDetailsDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Управление картами',
                  subtitle: 'Блокировка, замена карт',
                  onTap: () => _showCardManagementDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.history_outlined,
                  title: 'История операций',
                  subtitle: 'Все транзакции',
                  onTap: () => _showTransactionHistoryDialog(),
                ),
              ],
            ),

            _buildMenuSection(
              title: 'Поддержка',
              items: [
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Справочный центр',
                  subtitle: 'FAQ и инструкции',
                  onTap: () => _showHelpDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Связаться с поддержкой',
                  subtitle: 'Чат с оператором',
                  onTap: () => _showContactSupportDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'О приложении',
                  subtitle: 'Версия 1.0.0',
                  onTap: () => _showAboutDialog(),
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Выйти',
                  subtitle: 'Выйти из аккаунта',
                  onTap: () => _showLogoutDialog(),
                ),
              ],
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
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
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.zamanPersianGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.zamanPersianGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.grey.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey.withOpacity(0.5),
                size: 16,
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

  void _showContactDialog(String type) {
    _showSimpleDialog('Обновить $type', 'Функция обновления $type будет реализована здесь.');
  }

  void _showChangePasswordDialog() {
    _showSimpleDialog('Изменить пароль', 'Функция изменения пароля будет реализована здесь.');
  }

  void _showBiometryDialog() {
    _showSimpleDialog('Биометрия', 'Настройки биометрической аутентификации будут реализованы здесь.');
  }

  void _showTwoFactorDialog() {
    _showSimpleDialog('Двухфакторная аутентификация', 'Настройки двухфакторной аутентификации будут реализованы здесь.');
  }

  void _showBankDetailsDialog() {
    _showSimpleDialog('Банковские реквизиты', 'Информация о банковских реквизитах будет отображена здесь.');
  }

  void _showCardManagementDialog() {
    _showSimpleDialog('Управление картами', 'Функция управления картами будет реализована здесь.');
  }

  void _showTransactionHistoryDialog() {
    _showSimpleDialog('История операций', 'История всех транзакций будет отображена здесь.');
  }

  void _showHelpDialog() {
    _showSimpleDialog('Справочный центр', 'FAQ и справочные материалы будут реализованы здесь.');
  }

  void _showContactSupportDialog() {
    _showSimpleDialog('Связаться с поддержкой', 'Функция связи с поддержкой будет реализована здесь.');
  }

  void _showAboutDialog() {
    _showSimpleDialog('О приложении', 'Zaman Bank - Исламские банковские решения\nВерсия 1.0.0');
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