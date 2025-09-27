import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../super_admin/super_admin_dashboard.dart';

class ChangeCredentialsScreen extends StatefulWidget {
  const ChangeCredentialsScreen({super.key});

  @override
  State<ChangeCredentialsScreen> createState() => _ChangeCredentialsScreenState();
}

class _ChangeCredentialsScreenState extends State<ChangeCredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldMobileController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newMobileController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFirstStep = true;

  @override
  void dispose() {
    _oldMobileController.dispose();
    _oldPasswordController.dispose();
    _newMobileController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyOldCredentials() async {
    if (_formKey.currentState!.validate()) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.login(
        _oldMobileController.text.trim(),
        _oldPasswordController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _isFirstStep = false;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Invalid credentials'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _updateCredentials() async {
    if (_formKey.currentState!.validate()) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.updateSuperAdminCredentials(
        _newMobileController.text.trim(),
        _newPasswordController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credentials updated successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuperAdminDashboard()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Update failed'),
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
        title: const Text('Setup Super Admin'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF9333EA),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Setup Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.security,
                      size: 40,
                      color: Color(0xFF6B46C1),
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 600.ms),
                  
                  const SizedBox(height: 30),
                  
                  // Title
                  Text(
                    _isFirstStep ? 'Verify Old Credentials' : 'Set New Credentials',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    _isFirstStep 
                        ? 'Enter your current mobile and password'
                        : 'Create your new mobile and password',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 40),
                  
                  // Form
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _isFirstStep ? _buildOldCredentialsForm() : _buildNewCredentialsForm(),
                      ),
                    ),
                  )
                      .animate(delay: 900.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOldCredentialsForm() {
    return [
      // Old Mobile Field
      TextFormField(
        controller: _oldMobileController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Current Mobile Number',
          prefixIcon: Icon(Icons.phone),
          hintText: 'Enter current mobile number',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter mobile number';
          }
          if (value.length != 10) {
            return 'Please enter valid 10-digit mobile number';
          }
          return null;
        },
      )
          .animate(delay: 1200.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 20),
      
      // Old Password Field
      TextFormField(
        controller: _oldPasswordController,
        obscureText: _obscureOldPassword,
        decoration: InputDecoration(
          labelText: 'Current Password',
          prefixIcon: const Icon(Icons.lock),
          hintText: 'Enter current password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureOldPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureOldPassword = !_obscureOldPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
      )
          .animate(delay: 1500.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 30),
      
      // Verify Button
      Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ElevatedButton(
            onPressed: authProvider.isLoading ? null : _verifyOldCredentials,
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
                    'Verify Credentials',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          );
        },
      )
          .animate(delay: 1800.ms)
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.3, end: 0),
    ];
  }

  List<Widget> _buildNewCredentialsForm() {
    return [
      // New Mobile Field
      TextFormField(
        controller: _newMobileController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'New Mobile Number',
          prefixIcon: Icon(Icons.phone),
          hintText: 'Enter new mobile number',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter mobile number';
          }
          if (value.length != 10) {
            return 'Please enter valid 10-digit mobile number';
          }
          return null;
        },
      )
          .animate(delay: 1200.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 20),
      
      // New Password Field
      TextFormField(
        controller: _newPasswordController,
        obscureText: _obscureNewPassword,
        decoration: InputDecoration(
          labelText: 'New Password',
          prefixIcon: const Icon(Icons.lock),
          hintText: 'Enter new password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      )
          .animate(delay: 1500.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 20),
      
      // Confirm Password Field
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          labelText: 'Confirm New Password',
          prefixIcon: const Icon(Icons.lock_outline),
          hintText: 'Confirm new password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm password';
          }
          if (value != _newPasswordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      )
          .animate(delay: 1800.ms)
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.3, end: 0),
      
      const SizedBox(height: 30),
      
      // Update Button
      Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ElevatedButton(
            onPressed: authProvider.isLoading ? null : _updateCredentials,
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
                    'Update Credentials',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          );
        },
      )
          .animate(delay: 2100.ms)
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.3, end: 0),
    ];
  }
}
