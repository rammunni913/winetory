import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../providers/shop_provider.dart';
import '../../models/shop_model.dart';
import '../../utils/theme.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _ownerNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  Future<void> _addShop() async {
    if (_formKey.currentState!.validate()) {
      ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
      
      // Generate shop code
      String shopCode = await shopProvider.generateShopCode();
      
      // Create shop model
      ShopModel shop = ShopModel(
        id: const Uuid().v4(),
        shopCode: shopCode,
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        contact: _contactController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        ownerName: _ownerNameController.text.trim().isEmpty ? null : _ownerNameController.text.trim(),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = await shopProvider.createShop(shop);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shop added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(shopProvider.errorMessage ?? 'Failed to add shop'),
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
        title: const Text('Add New Shop'),
        actions: [
          Consumer<ShopProvider>(
            builder: (context, shopProvider, child) {
              return TextButton(
                onPressed: shopProvider.isLoading ? null : _addShop,
                child: shopProvider.isLoading
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
                      Icons.store,
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
                      'Add New Shop',
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
                      'Enter shop details to add to your network',
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
              
              // Shop Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Shop Name *',
                  prefixIcon: Icon(Icons.store),
                  hintText: 'Enter shop name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter shop name';
                  }
                  return null;
                },
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Address
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'Enter complete address',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Contact Number
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Number *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter 10-digit mobile number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (value.trim().length != 10) {
                    return 'Please enter valid 10-digit mobile number';
                  }
                  return null;
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Email (Optional)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter email address',
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return 'Please enter valid email address';
                    }
                  }
                  return null;
                },
              )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Owner Name (Optional)
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name (Optional)',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter owner name',
                ),
              )
                  .animate(delay: 1400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<ShopProvider>(
                builder: (context, shopProvider, child) {
                  return ElevatedButton(
                    onPressed: shopProvider.isLoading ? null : _addShop,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: shopProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Shop',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              )
                  .animate(delay: 1600.ms)
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
                        'Shop code will be automatically generated after saving.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 1800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
