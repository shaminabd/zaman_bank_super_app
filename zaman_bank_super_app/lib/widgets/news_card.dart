import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/stock_details_screen.dart';

class NewsCard extends StatelessWidget {
  final String companyName;
  final String companyLogo;
  final String headline;
  final String description;
  final String timeAgo;
  final double priceChange;
  final double priceChangePercent;

  const NewsCard({
    super.key,
    required this.companyName,
    required this.companyLogo,
    required this.headline,
    required this.description,
    required this.timeAgo,
    required this.priceChange,
    required this.priceChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = priceChange >= 0;
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StockDetailsScreen(
              stockSymbol: companyName,
              stockName: _getCompanyFullName(companyName),
              currentPrice: 150.0 + priceChange,
              priceChange: priceChange,
              priceChangePercent: priceChangePercent,
              quantityOwned: 10,
              halalStatus: 'Halal',
              halalExplanation: 'This stock complies with Islamic investment principles and is free from haram elements.',
            ),
          ),
        );
      },
      child: Container(
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
          children: [
            // Company Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  companyLogo,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // News Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    Text(
                      '\$${priceChange.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '(${isPositive ? '+' : ''}${priceChangePercent.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCompanyFullName(String symbol) {
    switch (symbol) {
      case 'AAPL':
        return 'Apple Inc.';
      case 'GOOGL':
        return 'Alphabet Inc.';
      case 'TSLA':
        return 'Tesla Inc.';
      case 'AMZN':
        return 'Amazon.com Inc.';
      default:
        return '$symbol Inc.';
    }
  }
}

