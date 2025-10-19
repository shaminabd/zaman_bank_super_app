import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/broker_portfolio_screen.dart';

class BrokerageButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const BrokerageButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Default navigation to Portfolio screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BrokerPortfolioScreen(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.zamanSolar,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
