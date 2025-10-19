import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class TransactionCard extends StatelessWidget {
  final String symbol;
  final String companyName;
  final String date;
  final int quantity;
  final double pricePerShare;
  final double totalAmount;
  final bool isPurchase;

  const TransactionCard({
    super.key,
    required this.symbol,
    required this.companyName,
    required this.date,
    required this.quantity,
    required this.pricePerShare,
    required this.totalAmount,
    required this.isPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isPurchase 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPurchase ? Icons.arrow_upward : Icons.arrow_downward,
              color: isPurchase ? Colors.green : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${symbol.substring(0, 8)}...',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPurchase ? '+' : '-'}${totalAmount.toStringAsFixed(0)} ₸',
                style: TextStyle(
                  color: isPurchase ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isPurchase ? 'Доход' : 'Расход',
                style: TextStyle(
                  color: isPurchase ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Халяль',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

