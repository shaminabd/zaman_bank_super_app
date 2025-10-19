import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StockSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const StockSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Search for stocks and companies',
          hintStyle: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

