import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FundsTransferScreen extends StatefulWidget {
  const FundsTransferScreen({super.key});

  @override
  State<FundsTransferScreen> createState() => _FundsTransferScreenState();
}

class _FundsTransferScreenState extends State<FundsTransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<TextEditingController> _securityCodeControllers = List.generate(6, (index) => TextEditingController());
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  
  String selectedTransferSource = 'Linked Bank Account';
  String selectedRecipientType = 'Card'; // 'Card' or 'Phone'
  
  final String recipientName = 'Eleanor Pena';
  final String recipientAccount = '**** **** **** 1234';

  @override
  void dispose() {
    _amountController.dispose();
    _cardNumberController.dispose();
    _phoneNumberController.dispose();
    for (var controller in _securityCodeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Перевод средств',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount to Transfer
            const Text(
              'Сумма для перевода',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Введите сумму',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                  ),
                  prefixText: '₸ ',
                  prefixStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recipient Type Selection
            const Text(
              'Отправить на:',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildRecipientTypeOption(
                    'Карта',
                    Icons.credit_card,
                    selectedRecipientType == 'Card',
                    () => setState(() => selectedRecipientType = 'Card'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRecipientTypeOption(
                    'Телефон',
                    Icons.phone,
                    selectedRecipientType == 'Phone',
                    () => setState(() => selectedRecipientType = 'Phone'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Recipient Input based on selection
            if (selectedRecipientType == 'Card') ...[
              const Text(
                'Номер карты',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  decoration: const InputDecoration(
                    hintText: '1234 5678 9012 3456',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'Номер телефона',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: '+77 123 456 7890',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Transfer from: (Source)
            const Text(
              'Перевести с:',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Linked Bank Account Option
            _buildTransferSourceOption(
              'Привязанный банковский счет',
              selectedTransferSource == 'Linked Bank Account',
              () => setState(() => selectedTransferSource = 'Linked Bank Account'),
            ),
            
            const SizedBox(height: 12),
            
            // Saved Card Option
            _buildTransferSourceOption(
              'Сохраненная карта',
              selectedTransferSource == 'Saved Card',
              () => setState(() => selectedTransferSource = 'Saved Card'),
            ),
            
            const SizedBox(height: 24),
            
            // Security Code
            const Text(
              'Код безопасности',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Введите 6-значный код, отправленный на ваш мобильный.',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            
            // Security Code Input Fields
            Row(
              children: List.generate(6, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _securityCodeControllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 32),
            
            // Transfer Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement transfer functionality
                  _showTransferConfirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zamanPersianGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Перевести',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientTypeOption(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.zamanPersianGreen : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.zamanPersianGreen : const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferSourceOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.zamanPersianGreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.zamanPersianGreen : AppColors.white,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        color: AppColors.white,
                        size: 12,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Подтвердить перевод',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Вы уверены, что хотите перевести \$${_amountController.text} на $recipientName используя $selectedTransferSource?',
          style: const TextStyle(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Отмена',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // TODO: Process transfer
            },
            child: const Text(
              'Подтвердить',
              style: TextStyle(color: AppColors.zamanPersianGreen),
            ),
          ),
        ],
      ),
    );
  }
}
