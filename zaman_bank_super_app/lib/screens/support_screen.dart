import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/bottom_navigation.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int _selectedIndex = 3;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Поддержка',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Привет, как мы можем помочь?',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Поиск справочных статей',
                  hintStyle: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Help Categories
            Expanded(
              child: ListView(
                children: [
                  _buildHelpCategory(
                    title: 'Начало работы',
                    onTap: () {
                      // TODO: Navigate to getting started articles
                    },
                  ),
                  _buildHelpCategory(
                    title: 'Аккаунт и биллинг',
                    onTap: () {
                      // TODO: Navigate to account & billing articles
                    },
                  ),
                  _buildHelpCategory(
                    title: 'Инвестиции',
                    onTap: () {
                      // TODO: Navigate to investing articles
                    },
                  ),
                  _buildHelpCategory(
                    title: 'Безопасность',
                    onTap: () {
                      // TODO: Navigate to security articles
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Open AI chat
        },
        backgroundColor: AppColors.teal,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: AppColors.white,
          size: 24,
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

  Widget _buildHelpCategory({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: const Color(0xFFF8F9FA),
      ),
    );
  }
}

