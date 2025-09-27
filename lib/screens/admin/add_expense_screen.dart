import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../providers/expense_provider.dart';
import '../../models/expense_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedType = AppConstants.dukaanExpense;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _addExpense() async {
    if (_formKey.currentState!.validate()) {
      ExpenseProvider expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      
      ExpenseModel expense = ExpenseModel(
        id: const Uuid().v4(),
        type: _selectedType,
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        shopId: 'current_shop_id', // This should be the current user's shop
        expenseDate: _selectedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = await expenseProvider.createExpense(expense);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(expenseProvider.errorMessage ?? 'Failed to add expense'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          Consumer<ExpenseProvider>(
            builder: (context, expenseProvider, child) {
              return TextButton(
                onPressed: expenseProvider.isLoading ? null : _addExpense,
                child: expenseProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.warningColor, AppTheme.errorColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.money_off,
                      size: 48,
                      color: Colors.white,
                    )
                        .animate()
                        .scale(
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Add Expense',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Record shop or commission expenses',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Expense Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Expense Type *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: [
                  DropdownMenuItem(
                    value: AppConstants.dukaanExpense,
                    child: Row(
                      children: [
                        Icon(Icons.store, color: AppTheme.warningColor),
                        const SizedBox(width: 12),
                        const Text('Dukaan Kharcha Khata'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.commissionExpense,
                    child: Row(
                      children: [
                        Icon(Icons.percent, color: AppTheme.errorColor),
                        const SizedBox(width: 12),
                        const Text('Commission Kharcha Khata'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select expense type';
                  }
                  return null;
                },
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: _selectedType == AppConstants.dukaanExpense 
                      ? 'Expense Description *' 
                      : 'Commission Description *',
                  prefixIcon: const Icon(Icons.description),
                  hintText: _selectedType == AppConstants.dukaanExpense 
                      ? 'e.g., Tea for staff, Disposable Glasses, VIP Water, Cleaning'
                      : 'e.g., Commission loss from sale transaction',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter expense description';
                  }
                  return null;
                },
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Enter expense amount',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter valid amount';
                  }
                  if (double.parse(value.trim()) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Date
              InkWell(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Expense Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child) {
                  return ElevatedButton(
                    onPressed: expenseProvider.isLoading ? null : _addExpense,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: expenseProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Expense',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              )
                  .animate(delay: 1400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getExpenseTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getExpenseTypeColor().withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getExpenseTypeIcon(),
                      color: _getExpenseTypeColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getExpenseTypeInfo(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getExpenseTypeColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 1600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getExpenseTypeIcon() {
    switch (_selectedType) {
      case 'Dukaan Kharcha Khata':
        return Icons.store;
      case 'Commission Kharcha Khata':
        return Icons.percent;
      default:
        return Icons.money_off;
    }
  }

  Color _getExpenseTypeColor() {
    switch (_selectedType) {
      case 'Dukaan Kharcha Khata':
        return AppTheme.warningColor;
      case 'Commission Kharcha Khata':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getExpenseTypeInfo() {
    switch (_selectedType) {
      case 'Dukaan Kharcha Khata':
        return 'Shop expenses like tea for staff, disposable glasses, VIP water, cleaning, etc.';
      case 'Commission Kharcha Khata':
        return 'Commission loss when selling below admin rate (Admin Rate - Sale Rate = Commission Loss).';
      default:
        return 'Select an expense type to see information.';
    }
  }
}
