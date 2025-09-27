
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
      
      String? shopName;
      if (_selectedShopId != null) {
        var shop = shopProvider.getShopById(_selectedShopId!);
        shopName = shop?.name;
      }
      
      UserModel user = UserModel(
        id: const Uuid().v4(), // Placeholder ID
        mobile: _mobileController.text.trim(),
        role: _selectedRole,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        shopId: _selectedShopId,
        shopName: shopName,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success = await authProvider.createUser(user, _passwordController.text.trim());
      
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
              // ... (Header code remains the same)

              const SizedBox(height: 32),
              
              // Role Selection
              // ... (Role selection code remains the same)
              
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
              ).animate(delay: 1000.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
              
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
              ).animate(delay: 1200.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),

              // Email (Mandatory)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter email address',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ).animate(delay: 1400.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),

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
              ).animate(delay: 1600.ms).fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
              
              // ... (Shop selection and other widgets remain the same)
            ],
          ),
        ),
      ),
    );
  }
}
