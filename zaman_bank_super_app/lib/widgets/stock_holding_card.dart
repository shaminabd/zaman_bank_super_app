import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StockHoldingCard extends StatelessWidget {
  final String symbol;
  final String companyName;
  final int shares;
  final double pricePerShare;
  final double totalValue;
  final String logo;
  final VoidCallback onTap;

  const StockHoldingCard({
    super.key,
    required this.symbol,
    required this.companyName,
    required this.shares,
    required this.pricePerShare,
    required this.totalValue,
    required this.logo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                color: AppColors.zamanCloud,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  logo,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Stock Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$shares Shares',
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Value Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${totalValue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${pricePerShare.toStringAsFixed(2)}/share',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
