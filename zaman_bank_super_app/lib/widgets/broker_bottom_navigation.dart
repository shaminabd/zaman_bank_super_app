import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../utils/page_transitions.dart';

class BrokerBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BrokerBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Главная',
                index: 0,
                isSelected: selectedIndex == 0,
                onTap: () {
                  // Navigate to home and clear the stack to prevent back navigation issues
                  Navigator.of(context).pushAndRemoveUntil(
                    PageTransitions.fadeTransition(page: const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.zamanPersianGreen.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.zamanPersianGreen : AppColors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.zamanPersianGreen : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
