import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../providers/sales_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/stock_provider.dart';
import '../../models/sales_model.dart';
import '../../utils/theme.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedProductId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
      Provider.of<StockProvider>(context, listen: false).fetchStock(),
    ]);
  }

  Future<void> _recordSale() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProductId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a product'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      SalesProvider salesProvider = Provider.of<SalesProvider>(context, listen: false);
      ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
      StockProvider stockProvider = Provider.of<StockProvider>(context, listen: false);
      
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
      double totalAmount = quantity * unitPrice;
      
      // Calculate commission (if selling below admin rate)
      double commission = 0;
      if (unitPrice < product.unitPrice) {
        commission = product.unitPrice - unitPrice;
      }

      // Generate invoice number
      String invoiceNumber = await salesProvider.generateInvoiceNumber('current_shop_id');

      SalesModel sale = SalesModel(
        id: const Uuid().v4(),
        invoiceNumber: invoiceNumber,
        productId: _selectedProductId!,
        productName: product.name,
        shopId: 'current_shop_id', // This should be the current user's shop
        salesmanId: 'current_salesman_id', // This should be the current user's ID
        customerName: _customerNameController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        totalAmount: totalAmount,
        commission: commission,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        saleDate: _selectedDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = await salesProvider.createSale(sale);
      
      if (success) {
        // Update stock
        await stockProvider.addSale(
          _selectedProductId!,
          product.name,
          'current_shop_id',
          product.category,
          quantity,
          unitPrice,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sale recorded successfully'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(salesProvider.errorMessage ?? 'Failed to record sale'),
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
        title: const Text('Record Sale'),
        actions: [
          Consumer<SalesProvider>(
            builder: (context, salesProvider, child) {
              return TextButton(
                onPressed: salesProvider.isLoading ? null : _recordSale,
                child: salesProvider.isLoading
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
                      Icons.point_of_sale,
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
                      'Record Sale',
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
                      'Record a new sales transaction',
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
              
              // Product Selection
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedProductId,
                    decoration: const InputDecoration(
                      labelText: 'Select Product *',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    items: productProvider.products.where((p) => p.isActive).map((product) => 
                      DropdownMenuItem(
                        value: product.id,
                        child: Text('${product.name} (${product.brand}) - ₹${product.unitPrice.toStringAsFixed(0)}'),
                      ),
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                        if (value != null) {
                          var product = productProvider.getProductById(value);
                          if (product != null) {
                            _unitPriceController.text = product.unitPrice.toString();
                          }
                        }
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
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Customer Name
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name *',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter customer name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Customer Phone
              TextFormField(
                controller: _customerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Customer Phone *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter customer phone number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter customer phone';
                  }
                  if (value.trim().length != 10) {
                    return 'Please enter valid 10-digit phone number';
                  }
                  return null;
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
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
                  if (int.parse(value.trim()) <= 0) {
                    return 'Quantity must be greater than 0';
                  }
                  return null;
                },
              )
                  .animate(delay: 1200.ms)
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
                  if (double.parse(value.trim()) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              )
                  .animate(delay: 1400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Sale Date
              InkWell(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
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
                    labelText: 'Sale Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              )
                  .animate(delay: 1600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Enter any additional notes',
                ),
              )
                  .animate(delay: 1800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<SalesProvider>(
                builder: (context, salesProvider, child) {
                  return ElevatedButton(
                    onPressed: salesProvider.isLoading ? null : _recordSale,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: salesProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Record Sale',
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
                        'Stock will be automatically updated after recording the sale. Commission will be calculated if selling below admin rate.',
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
}
