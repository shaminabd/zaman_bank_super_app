import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StockDetailsScreen extends StatefulWidget {
  final String stockSymbol;
  final String stockName;
  final double currentPrice;
  final double priceChange;
  final double priceChangePercent;
  final int quantityOwned;
  final String halalStatus;
  final String halalExplanation;

  const StockDetailsScreen({
    super.key,
    required this.stockSymbol,
    required this.stockName,
    required this.currentPrice,
    required this.priceChange,
    required this.priceChangePercent,
    required this.quantityOwned,
    required this.halalStatus,
    required this.halalExplanation,
  });

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  String selectedTimeRange = '1D';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zamanCloud,
      appBar: AppBar(
        backgroundColor: AppColors.zamanCloud,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.stockSymbol,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: AppColors.black),
            onPressed: () {
              // TODO: Add to watchlist
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock Overview
              _buildStockOverview(),
              const SizedBox(height: 24),
              
              // Stock Chart Placeholder
              _buildStockChart(),
              const SizedBox(height: 24),
              
              // Halal Analysis Section
              _buildHalalAnalysis(),
              const SizedBox(height: 24),
              
              // Detailed Analysis
              _buildDetailedAnalysis(),
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.stockName,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${widget.currentPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              widget.priceChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: widget.priceChange >= 0 ? Colors.green : Colors.red,
              size: 16,
            ),
            Text(
              '+\$${widget.priceChange.toStringAsFixed(2)} (${widget.priceChangePercent.toStringAsFixed(2)}%) Сегодня',
              style: TextStyle(
                color: widget.priceChange >= 0 ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard('Количество в собственности', '${widget.quantityOwned}'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard('Общая стоимость', '\$${(widget.currentPrice * widget.quantityOwned).toStringAsFixed(2)}'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockChart() {
    return Container(
      height: 200,
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
      child: Stack(
        children: [
          // Chart placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart,
                  color: AppColors.grey,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'График акций',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Time range selector
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['1D', '5D', '1M', '6M', '1Y', '5Y'].map((range) {
                final isSelected = range == selectedTimeRange;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeRange = range;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.zamanPersianGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.zamanPersianGreen : AppColors.grey,
                      ),
                    ),
                    child: Text(
                      range,
                      style: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHalalAnalysis() {
    Color statusColor;
    IconData statusIcon;
    
    switch (widget.halalStatus.toLowerCase()) {
      case 'halal':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'non-halal':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'suspicious':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: AppColors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Анализ Халяль: ${widget.halalStatus}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.halalExplanation,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Анализ отрасли',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.stockName} работает в технологическом секторе. Основные источники дохода компании - потребительская электроника и программные услуги, которые считаются допустимыми согласно исламским принципам инвестирования.',
          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Финансовая разбивка:',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildFinancialMetric('Соотношение долг/активы', '35%', 'Предпочтительно ниже 33%'),
        _buildFinancialMetric('Недопустимый доход', '2%', 'Ниже порога 5%'),
        _buildFinancialMetric('Некорректные инвестиции', '1%', 'Ниже порога 33%'),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            // TODO: Navigate to learn more page
          },
          child: const Text(
            'Узнать больше →',
            style: TextStyle(
              color: AppColors.zamanPersianGreen,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialMetric(String label, String value, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '($description)',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement buy functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zamanSolar,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Купить',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement sell functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zamanPersianGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Продать',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement hold functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.zamanPersianGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Держать',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
