import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Support & Assistance',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                title: 'Live Chat Support',
                subtitle: 'Get instant help from our investment specialists',
                onTap: () {
                  // TODO: Open live chat
                },
              ),
              const Divider(),
              _buildSupportOption(
                icon: Icons.phone_outlined,
                title: 'Phone Support',
                subtitle: '+1 (555) 123-4567 • Available 24/7',
                onTap: () {
                  // TODO: Make phone call
                },
              ),
              const Divider(),
              _buildSupportOption(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'brokerage@zamanbank.com',
                onTap: () {
                  // TODO: Open email client
                },
              ),
              const Divider(),
              _buildSupportOption(
                icon: Icons.help_outline,
                title: 'FAQ & Help Center',
                subtitle: 'Find answers to common investment questions',
                onTap: () {
                  // TODO: Navigate to FAQ
                },
              ),
              const Divider(),
              _buildSupportOption(
                icon: Icons.schedule_outlined,
                title: 'Schedule Consultation',
                subtitle: 'Book a one-on-one session with our advisors',
                onTap: () {
                  // TODO: Navigate to booking
                },
              ),
            ],
          ),
        ),
      ],
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

