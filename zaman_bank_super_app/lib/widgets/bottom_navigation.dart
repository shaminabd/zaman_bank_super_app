import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../screens/transfer_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/page_transitions.dart';
import '../providers/chat_notification_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Главная',
                index: 0,
                isSelected: selectedIndex == 0,
                onTap: () {
                  if (selectedIndex != 0) {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransitions.fadeTransition(page: const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
              _buildNavItem(
                icon: Icons.swap_horiz,
                label: 'Переводы',
                index: 1,
                isSelected: selectedIndex == 1,
                onTap: () {
                  if (selectedIndex != 1) {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransitions.fadeTransition(page: const TransferScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
              Consumer<ChatNotificationProvider>(
                builder: (context, chatProvider, child) {
                  return _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Чат с банком',
                    index: 2,
                    isSelected: selectedIndex == 2,
                    hasUnread: chatProvider.hasUnreadMessages,
                    onTap: () {
                      if (selectedIndex != 2) {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageTransitions.fadeTransition(page: const ChatScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Профиль',
                index: 3,
                isSelected: selectedIndex == 3,
                onTap: () {
                  if (selectedIndex != 3) {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransitions.fadeTransition(page: const ProfileScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
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
    bool hasUnread = false,
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
            Stack(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.zamanPersianGreen : AppColors.grey,
                  size: 24,
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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
