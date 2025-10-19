import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/stock_holding_card.dart';
import 'stock_details_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zamanCloud,
      appBar: AppBar(
        backgroundColor: AppColors.zamanCloud,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.black),
          onPressed: () {
            // TODO: Open drawer
          },
        ),
        title: const Text(
          'Мой портфель',
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
              // Account Summary Cards
              Row(
                children: [
                  Expanded(
                    child: PortfolioCard(
                      title: 'Общий баланс счета',
                      value: '\$15,432.50',
                      change: '+2.5%',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PortfolioCard(
                      title: 'Общая стоимость портфеля',
                      value: '\$14,210.00',
                      change: '-1.8%',
                      isPositive: false,
                    ),
                  ),
                ],
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
                    shares: 10,
                    pricePerShare: 175.50,
                    totalValue: 1755.00,
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
                            quantityOwned: 10,
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
                    shares: 5,
                    pricePerShare: 250.00,
                    totalValue: 1250.00,
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
                            quantityOwned: 5,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StockHoldingCard(
                    symbol: 'AMZN',
                    companyName: 'Amazon.com, Inc.',
                    shares: 2,
                    pricePerShare: 140.00,
                    totalValue: 280.00,
                    logo: '📦',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'AMZN',
                            stockName: 'Amazon.com, Inc.',
                            currentPrice: 140.00,
                            priceChange: 1.20,
                            priceChangePercent: 0.9,
                            quantityOwned: 2,
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
                    companyName: 'Alphabet Inc. - Class A',
                    shares: 3,
                    pricePerShare: 130.00,
                    totalValue: 390.00,
                    logo: '🔍',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StockDetailsScreen(
                            stockSymbol: 'GOOGL',
                            stockName: 'Alphabet Inc. - Class A',
                            currentPrice: 130.00,
                            priceChange: -2.10,
                            priceChangePercent: -1.6,
                            quantityOwned: 3,
                            halalStatus: 'Халяль',
                            halalExplanation: 'Эта акция соответствует исламским принципам инвестирования и свободна от харамных элементов.',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
