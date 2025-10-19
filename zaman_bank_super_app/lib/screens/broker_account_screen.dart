import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/broker_bottom_navigation.dart';
import '../widgets/stock_search_bar.dart';
import '../widgets/news_card.dart';
import '../widgets/brokerage_button.dart';
import '../utils/page_transitions.dart';
import '../utils/navigation_utils.dart';
import 'broker_portfolio_screen.dart';

class BrokerAccountScreen extends StatefulWidget {
  const BrokerAccountScreen({super.key});

  @override
  State<BrokerAccountScreen> createState() => _BrokerAccountScreenState();
}

class _BrokerAccountScreenState extends State<BrokerAccountScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
          'Брокерский счет',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.black),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: StockSearchBar(
                controller: _searchController,
                onSearch: (query) {
                  // TODO: Implement search functionality
                },
              ),
            ),
            
            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BrokerageButton(
                    icon: Icons.pie_chart_outline,
                    label: 'Портфель',
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransitions.slideFromRight(
                          page: const BrokerPortfolioScreen(),
                        ),
                      );
                    },
                  ),
                  BrokerageButton(
                    icon: Icons.trending_up,
                    label: 'Рынок',
                    onTap: () {
                      // TODO: Navigate to market screen
                    },
                  ),
                  BrokerageButton(
                    icon: Icons.bookmark_outline,
                    label: 'Список наблюдения',
                    onTap: () {
                      // TODO: Navigate to watchlist screen
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Market Updates Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Обновления рынка',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // News Cards
                  SizedBox(
                    height: 400,
                    child: ListView(
                      children: const [
                        NewsCard(
                          companyName: 'AAPL',
                          companyLogo: '🍎',
                          headline: 'Apple сообщает о сильной прибыли в Q4',
                          description: 'Акции AAPL выросли на 5% после превышения ожиданий по выручке благодаря сильным продажам iPhone.',
                          timeAgo: '2 часа назад',
                          priceChange: 8.50,
                          priceChangePercent: 2.1,
                        ),
                        SizedBox(height: 12),
                        NewsCard(
                          companyName: 'TSLA',
                          companyLogo: '⚡',
                          headline: 'Tesla объявляет о новой Гигафабрике',
                          description: 'Акции TSLA выросли на 3% после объявления о новом производственном объекте.',
                          timeAgo: '4 часа назад',
                          priceChange: 12.30,
                          priceChangePercent: 1.8,
                        ),
                        SizedBox(height: 12),
                        NewsCard(
                          companyName: 'GOOGL',
                          companyLogo: '🔍',
                          headline: 'Прорыв Google в области ИИ',
                          description: 'GOOGL вырос на 2% после объявления о крупном достижении в области ИИ для поисковых технологий.',
                          timeAgo: '6 часов назад',
                          priceChange: 4.20,
                          priceChangePercent: 1.2,
                        ),
                        SizedBox(height: 12),
                        NewsCard(
                          companyName: 'MSFT',
                          companyLogo: '🪟',
                          headline: 'Рост облачных сервисов Microsoft',
                          description: 'MSFT вырос на 1,5% благодаря сильному квартальному росту облачных сервисов Azure.',
                          timeAgo: '8 часов назад',
                          priceChange: 3.80,
                          priceChangePercent: 0.9,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Support Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Поддержка и помощь',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      children: [
                        _buildSupportOption(
                          icon: Icons.chat_bubble_outline,
                          title: 'Поддержка в чате',
                          subtitle: 'Получите мгновенную помощь от нашей команды поддержки',
                          onTap: () {
                            // TODO: Open live chat
                          },
                        ),
                        const Divider(),
                        _buildSupportOption(
                          icon: Icons.phone_outlined,
                          title: 'Телефонная поддержка',
                          subtitle: '+1 (555) 123-4567',
                          onTap: () {
                            // TODO: Make phone call
                          },
                        ),
                        const Divider(),
                        _buildSupportOption(
                          icon: Icons.email_outlined,
                          title: 'Поддержка по электронной почте',
                          subtitle: 'support@zamanbank.com',
                          onTap: () {
                            // TODO: Open email client
                          },
                        ),
                        const Divider(),
                        _buildSupportOption(
                          icon: Icons.help_outline,
                          title: 'FAQ и центр помощи',
                          subtitle: 'Найдите ответы на часто задаваемые вопросы',
                          onTap: () {
                            // TODO: Navigate to FAQ
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: BrokerBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.zamanPersianGreen,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
