import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/stock_holding_card.dart';
import '../widgets/support_section.dart';
import 'stock_details_screen.dart';

class BrokerPortfolioScreen extends StatefulWidget {
  const BrokerPortfolioScreen({super.key});

  @override
  State<BrokerPortfolioScreen> createState() => _BrokerPortfolioScreenState();
}

class _BrokerPortfolioScreenState extends State<BrokerPortfolioScreen> {
  int _selectedIndex = 1;

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
          'Брокерский портфель',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.black),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portfolio Summary Cards
              Row(
                children: [
                  Expanded(
                    child: PortfolioCard(
                      title: 'Стоимость портфеля',
                      value: '\$24,580.50',
                      change: '+5.2%',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PortfolioCard(
                      title: 'Баланс счета',
                      value: '\$2,450.00',
                      change: '+12.5%',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Single Balance Card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Общий баланс счета',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          '\$27,030.50',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '+8.7%',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Положительный баланс - Все инвестиции работают хорошо',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // My Holdings Section
              const Text(
                'Мои активы',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Stock Holdings
              Column(
                children: [
                  StockHoldingCard(
                    symbol: 'AAPL',
                    companyName: 'Apple Inc.',
                    shares: 25,
                    pricePerShare: 175.50,
                    totalValue: 4387.50,
                    logo: '🍎',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'AAPL',
                            stockName: 'Apple Inc.',
                            currentPrice: 175.50,
                            priceChange: 2.50,
                            priceChangePercent: 1.4,
                            quantityOwned: 25,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StockHoldingCard(
                    symbol: 'TSLA',
                    companyName: 'Tesla, Inc.',
                    shares: 15,
                    pricePerShare: 250.00,
                    totalValue: 3750.00,
                    logo: '⚡',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'TSLA',
                            stockName: 'Tesla, Inc.',
                            currentPrice: 250.00,
                            priceChange: -5.20,
                            priceChangePercent: -2.0,
                            quantityOwned: 15,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StockHoldingCard(
                    symbol: 'GOOGL',
                    companyName: 'Alphabet Inc.',
                    shares: 8,
                    pricePerShare: 130.00,
                    totalValue: 1040.00,
                    logo: '🔍',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'GOOGL',
                            stockName: 'Alphabet Inc.',
                            currentPrice: 130.00,
                            priceChange: -2.10,
                            priceChangePercent: -1.6,
                            quantityOwned: 8,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StockHoldingCard(
                    symbol: 'MSFT',
                    companyName: 'Microsoft Corp.',
                    shares: 12,
                    pricePerShare: 330.50,
                    totalValue: 3966.00,
                    logo: '🪟',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'MSFT',
                            stockName: 'Microsoft Corp.',
                            currentPrice: 330.50,
                            priceChange: 1.20,
                            priceChangePercent: 0.9,
                            quantityOwned: 12,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Support Section
              const SupportSection(),
            ],
          ),
        ),
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
}

