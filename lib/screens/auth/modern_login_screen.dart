import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/modern_button.dart';
import '../../widgets/modern_card.dart';
import '../super_admin/super_admin_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../salesman/salesman_dashboard.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    bool success = await authProvider.login(
      _mobileController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      _navigateToUserDashboard(authProvider.currentUser!.role);
    } else if (mounted) {
      _showErrorSnackBar(authProvider.errorMessage ?? 'Login failed');
    }
  }

  void _navigateToUserDashboard(String role) {
    Widget dashboard;
    switch (role) {
      case AppConstants.superAdminRole:
        dashboard = const SuperAdminDashboard();
        break;
      case AppConstants.adminRole:
        dashboard = const AdminDashboard();
        break;
      case AppConstants.salesmanRole:
        dashboard = const SalesmanDashboard();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => dashboard,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
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
              Color(0xFF1A237E),
              Color(0xFF3F51B5),
              Color(0xFF9C27B0),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                
                // Logo and Title
                AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - _slideController.value) * 100),
                      child: Opacity(
                        opacity: _slideController.value,
                        child: Column(
                          children: [
                            Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.wine_bar,
                                size: 50.sp,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: 24.h),
                            
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            Text(
                              'Sign in to continue to Wine TorY',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 50.h),
                
                // Login Form
                AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeController.value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - _fadeController.value) * 50),
                        child: ModernCard(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(24.w),
                          margin: EdgeInsets.zero,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: 32.h),
                                
                                // Mobile Number Field
                                _buildTextField(
                                  controller: _mobileController,
                                  label: 'Mobile Number',
                                  icon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter mobile number';
                                    }
                                    if (value!.length != 10) {
                                      return 'Mobile number must be 10 digits';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: 20.h),
                                
                                // Password Field
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  icon: Icons.lock,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter password';
                                    }
                                    if (value!.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: 32.h),
                                
                                // Login Button
                                PrimaryButton(
                                  text: 'Login',
                                  onPressed: _handleLogin,
                                  isLoading: _isLoading,
                                  icon: Icons.login,
                                ),
                                
                                SizedBox(height: 16.h),
                                
                                // Registration Info
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: Colors.green.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.admin_panel_settings,
                                            color: Colors.green.shade600,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'First Time Setup?',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Create your Super Admin account first using the registration page.',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      GestureDetector(
                                        onTap: () {
                                          // Open registration page in new tab
                                          // This will be handled by the web app
                                        },
                                        child: Text(
                                          'Open Registration Page →',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.grey.shade600,
              size: 20.sp,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey.shade600,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                : null,
            hintText: 'Enter $label',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF1A237E),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}
