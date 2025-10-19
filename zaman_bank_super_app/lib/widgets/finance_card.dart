import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FinanceCard extends StatelessWidget {
  const FinanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Исламское финансирование',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'до 3 000 000 ₸',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Получить',
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
            decoration: const BoxDecoration(
              color: AppColors.zamanPersianGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '₸',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
