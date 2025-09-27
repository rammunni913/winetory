import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/stock_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/shop_provider.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class AddStockTransactionScreen extends StatefulWidget {
  const AddStockTransactionScreen({super.key});

  @override
  State<AddStockTransactionScreen> createState() => _AddStockTransactionScreenState();
}

class _AddStockTransactionScreenState extends State<AddStockTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  
  String _selectedTransactionType = 'Purchase';
  String? _selectedProductId;
  String? _selectedShopId;
  String? _selectedToShopId;
  DateTime _selectedDate = DateTime.now();

  final List<String> _transactionTypes = [
    'Purchase',
    'Sale',
    'Transfer',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
    ]);
  }

  Future<void> _addTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProductId == null || _selectedShopId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select product and shop'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      StockProvider stockProvider = Provider.of<StockProvider>(context, listen: false);
      ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      var product = productProvider.getProductById(_selectedProductId!);
      if (product == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product not found'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      int quantity = int.parse(_quantityController.text.trim());
      double unitPrice = double.parse(_unitPriceController.text.trim());
      
      bool success = false;
      
      switch (_selectedTransactionType) {
        case 'Purchase':
          success = await stockProvider.addPurchase(
            _selectedProductId!,
            product.name,
            _selectedShopId!,
            product.category,
            quantity,
            unitPrice,
          );
          break;
        case 'Sale':
          success = await stockProvider.addSale(
            _selectedProductId!,
            product.name,
            _selectedShopId!,
            product.category,
            quantity,
            unitPrice,
          );
          break;
        case 'Transfer':
          if (_selectedToShopId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select destination shop for transfer'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            return;
          }
          success = await stockProvider.addTransfer(
            _selectedProductId!,
            product.name,
            _selectedShopId!,
            _selectedToShopId!,
            product.category,
            quantity,
            unitPrice,
          );
          break;
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(stockProvider.errorMessage ?? 'Failed to add transaction'),
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
        title: const Text('Add Stock Transaction'),
        actions: [
          Consumer<StockProvider>(
            builder: (context, stockProvider, child) {
              return TextButton(
                onPressed: stockProvider.isLoading ? null : _addTransaction,
                child: stockProvider.isLoading
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
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.swap_horiz,
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
                      'Add Stock Transaction',
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
                      'Record stock movements and transactions',
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
              
              // Transaction Type
              DropdownButtonFormField<String>(
                initialValue: _selectedTransactionType,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type *',
                  prefixIcon: Icon(Icons.swap_horiz),
                ),
                items: _transactionTypes.map((type) => 
                  DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select transaction type';
                  }
                  return null;
                },
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Product Selection
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Product *',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    items: productProvider.products.where((p) => p.isActive).map((product) => 
                      DropdownMenuItem(
                        value: product.id,
                        child: Text('${product.name} (${product.brand})'),
                      ),
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select product';
                      }
                      return null;
                    },
                  );
                },
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Shop Selection
              Consumer<ShopProvider>(
                builder: (context, shopProvider, child) {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedShopId,
                    decoration: InputDecoration(
                      labelText: _selectedTransactionType == 'Transfer' ? 'From Shop *' : 'Shop *',
                      prefixIcon: const Icon(Icons.store),
                    ),
                    items: shopProvider.getActiveShops().map((shop) => 
                      DropdownMenuItem(
                        value: shop.id,
                        child: Text(shop.name),
                      ),
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedShopId = value;
                        if (_selectedTransactionType == 'Transfer') {
                          _selectedToShopId = null; // Reset destination shop
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select shop';
                      }
                      return null;
                    },
                  );
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              // Destination Shop for Transfer
              if (_selectedTransactionType == 'Transfer') ...[
                const SizedBox(height: 20),
                
                Consumer<ShopProvider>(
                  builder: (context, shopProvider, child) {
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedToShopId,
                      decoration: const InputDecoration(
                        labelText: 'To Shop *',
                        prefixIcon: Icon(Icons.store),
                      ),
                      items: shopProvider.getActiveShops()
                          .where((shop) => shop.id != _selectedShopId)
                          .map((shop) => 
                        DropdownMenuItem(
                          value: shop.id,
                          child: Text(shop.name),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedToShopId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select destination shop';
                        }
                        return null;
                      },
                    );
                  },
                )
                    .animate(delay: 1200.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
              ],
              
              const SizedBox(height: 20),
              
              // Quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  prefixIcon: Icon(Icons.numbers),
                  hintText: 'Enter quantity',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              )
                  .animate(delay: 1400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Unit Price
              TextFormField(
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Unit Price *',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Enter unit price',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter unit price';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              )
                  .animate(delay: 1600.ms)
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
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              )
                  .animate(delay: 1800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<StockProvider>(
                builder: (context, stockProvider, child) {
                  return ElevatedButton(
                    onPressed: stockProvider.isLoading ? null : _addTransaction,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: stockProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              )
                  .animate(delay: 2000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.infoColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.infoColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getTransactionInfo(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 2200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  String _getTransactionInfo() {
    switch (_selectedTransactionType) {
      case 'Purchase':
        return 'Purchase will add stock to the selected shop.';
      case 'Sale':
        return 'Sale will reduce stock from the selected shop.';
      case 'Transfer':
        return 'Transfer will move stock from one shop to another.';
      default:
        return 'Select a transaction type to see information.';
    }
  }
}
