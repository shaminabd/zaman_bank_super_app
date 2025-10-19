import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CategorySelectionWidget extends StatelessWidget {
  final Function(String) onCategorySelected;
  final bool isDisabled;

  const CategorySelectionWidget({
    super.key,
    required this.onCategorySelected,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Близкие', 'category': 'CLOSE_ONES', 'icon': Icons.family_restroom, 'color': Colors.pink},
      {'name': 'Развлечения', 'category': 'ENTERTAINMENT', 'icon': Icons.movie, 'color': Colors.purple},
      {'name': 'Путешествия', 'category': 'TRAVEL', 'icon': Icons.flight, 'color': Colors.blue},
      {'name': 'Одежда', 'category': 'CLOTHES', 'icon': Icons.checkroom, 'color': Colors.orange},
      {'name': 'Еда', 'category': 'FOOD', 'icon': Icons.restaurant, 'color': Colors.green},
      {'name': 'Благотворительность', 'category': 'CHARITY', 'icon': Icons.favorite, 'color': Colors.red},
      {'name': 'Образование', 'category': 'EDUCATION', 'icon': Icons.school, 'color': Colors.indigo},
      {'name': 'Бизнес', 'category': 'BUSINESS', 'icon': Icons.business, 'color': Colors.teal},
      {'name': 'Другое', 'category': 'OTHER', 'icon': Icons.more_horiz, 'color': Colors.grey},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.zamanCloud,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.zamanPersianGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите категорию транзакции:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              return GestureDetector(
                onTap: isDisabled ? null : () {
                  onCategorySelected(category['category'] as String);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDisabled 
                        ? Colors.grey.withOpacity(0.3)
                        : (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDisabled 
                          ? Colors.grey.withOpacity(0.5)
                          : (category['color'] as Color).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 18,
                        color: isDisabled 
                            ? Colors.grey
                            : category['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDisabled 
                              ? Colors.grey
                              : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
