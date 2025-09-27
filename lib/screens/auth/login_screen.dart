import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import '../super_admin/super_admin_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../salesman/salesman_dashboard.dart';
import 'change_credentials_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegisterMode = false;
  bool _superAdminExists = false;

  @override
  void initState() {
    super.initState();
    _checkSuperAdminExists();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkSuperAdminExists() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'super_admin')
          .limit(1)
          .get();
      
      setState(() {
        _superAdminExists = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.login(
        _mobileController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        // Check if it's first time super admin login
        if (authProvider.currentUser?.mobile == AppConstants.defaultSuperAdminMobile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeCredentialsScreen(),
            ),
          );
        } else {
          _navigateToDashboard(authProvider.currentUser!.role);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login failed'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _registerSuperAdmin() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create Super Admin user in Firestore
        await FirebaseFirestore.instance.collection('users').add({
          'name': 'Super Admin',
          'mobile': _mobileController.text.trim(),
          'role': 'super_admin',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Super Admin registered successfully! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          
          setState(() {
            _isRegisterMode = false;
            _superAdminExists = true;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  void _navigateToDashboard(String role) {
    Widget dashboard;
    
    switch (role) {
      case 'super_admin':
        dashboard = const SuperAdminDashboard();
        break;
      case 'admin':
        dashboard = const AdminDashboard();
        break;
      case 'salesman':
        dashboard = const SalesmanDashboard();
        break;
      default:
        return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // App Logo
                  Container(
                    width: 100,
                    height: 100,
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
                      Icons.local_bar,
                      size: 50,
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
                  
                  // App Name
                  Text(
                    'Wine TorY',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    'Management System',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 50),
                  
                  // Login Form
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
                        children: [
                          Text(
                            _isRegisterMode ? 'Register Super Admin' : 'Login',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate(delay: 900.ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                          
                          const SizedBox(height: 30),
                          
                          // Mobile Number Field
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Enter your mobile number',
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
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Enter your password',
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
                          
                          // Login/Register Button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return ElevatedButton(
                                onPressed: authProvider.isLoading ? null : (_isRegisterMode ? _registerSuperAdmin : _login),
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
                                    : Text(
                                        _isRegisterMode ? 'Register' : 'Login',
                                        style: const TextStyle(
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
                          
                          const SizedBox(height: 20),
                          
                          // Register Super Admin Button (only if no super admin exists)
                          if (!_superAdminExists && !_isRegisterMode)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterMode = true;
                                });
                              },
                              child: const Text(
                                'Register First Super Admin',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                                .animate(delay: 2100.ms)
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.3, end: 0),
                          
                          // Cancel Registration Button (only in register mode)
                          if (_isRegisterMode)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterMode = false;
                                });
                              },
                              child: const Text(
                                'Cancel Registration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                                .animate(delay: 2100.ms)
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.3, end: 0),
                          
                          // Default Credentials Info (only if super admin exists)
                          if (_superAdminExists && !_isRegisterMode)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.infoColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.infoColor.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Default Super Admin Credentials',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.infoColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Mobile: ${AppConstants.defaultSuperAdminMobile}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.infoColor,
                                    ),
                                  ),
                                  Text(
                                    'Password: ${AppConstants.defaultSuperAdminPassword}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.infoColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate(delay: 2100.ms)
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.3, end: 0),
                        ],
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
}
