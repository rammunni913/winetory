import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedRole = AppConstants.adminRole;
  String? _selectedShopId;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ShopProvider>(context, listen: false).fetchShops();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
      
      // Get shop name if shop is selected
      String? shopName;
      if (_selectedShopId != null) {
        var shop = shopProvider.getShopById(_selectedShopId!);
        shopName = shop?.name;
      }
      
      // Create user model
      UserModel user = UserModel(
        id: const Uuid().v4(),
        mobile: _mobileController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        shopId: _selectedShopId,
        shopName: shopName,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = await authProvider.createUser(user);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Failed to add user'),
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
        title: const Text('Add New User'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return TextButton(
                onPressed: authProvider.isLoading ? null : _addUser,
                child: authProvider.isLoading
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
                      Icons.person_add,
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
                      'Add New User',
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
                      'Create a new user account',
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
              
              // Role Selection
              Text(
                'Select Role',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        value: AppConstants.adminRole,
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, color: AppTheme.infoColor),
                            const SizedBox(width: 12),
                            const Text('Admin'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.salesmanRole,
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppTheme.successColor),
                            const SizedBox(width: 12),
                            const Text('Salesman'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                        if (_selectedRole == AppConstants.salesmanRole) {
                          _selectedShopId = null; // Reset shop selection
                        }
                      });
                    },
                  ),
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 24),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter full name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Mobile Number
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter 10-digit mobile number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.trim().length != 10) {
                    return 'Please enter valid 10-digit mobile number';
                  }
                  return null;
                },
              )
                  .animate(delay: 1200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password *',
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Enter password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              )
                  .animate(delay: 1400.ms)
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
                  .animate(delay: 1600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              // Shop Selection (for Salesman)
              if (_selectedRole == AppConstants.salesmanRole) ...[
                const SizedBox(height: 20),
                
                Text(
                  'Assign to Shop',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate(delay: 1800.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
                
                const SizedBox(height: 12),
                
                Consumer<ShopProvider>(
                  builder: (context, shopProvider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedShopId,
                          isExpanded: true,
                          hint: const Text('Select Shop'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('No Shop Assigned'),
                            ),
                            ...shopProvider.getActiveShops().map((shop) => 
                              DropdownMenuItem<String?>(
                                value: shop.id,
                                child: Text(shop.name),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedShopId = value;
                            });
                          },
                        ),
                      ),
                    );
                  },
                )
                    .animate(delay: 2000.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
              ],
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _addUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              )
                  .animate(delay: 2200.ms)
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
                        _selectedRole == AppConstants.salesmanRole
                            ? 'Salesman will be assigned to the selected shop.'
                            : 'Admin will have access to all shops.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 2400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
