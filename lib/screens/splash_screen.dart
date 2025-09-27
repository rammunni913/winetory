import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'auth/modern_login_screen.dart';
import 'super_admin/super_admin_dashboard.dart';
import 'admin/admin_dashboard.dart';
import 'salesman/salesman_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  
  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Remove native splash screen
    FlutterNativeSplash.remove();
    
    // Start animations
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
    
    // Check authentication status
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isLoggedIn = await authProvider.checkAuthStatus();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      if (isLoggedIn && authProvider.currentUser != null) {
        _navigateToUserDashboard(authProvider.currentUser!.role);
      } else {
        Navigator.pushReplacement(
          context,
          _createRoute(const ModernLoginScreen()),
        );
      }
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
        dashboard = const ModernLoginScreen();
    }
    
    Navigator.pushReplacement(
      context,
      _createRoute(dashboard),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    // Logo Animation
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoController.value,
                          child: Transform.rotate(
                            angle: _logoController.value * 0.5,
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30.r),
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
                                size: 60.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // App Title with Shimmer Effect
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textController.value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - _textController.value) * 50),
                            child: Shimmer.fromColors(
                              baseColor: Colors.white70,
                              highlightColor: Colors.white,
                              period: const Duration(milliseconds: 1500),
                              child: Text(
                                'Wine TorY',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Subtitle
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textController.value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - _textController.value) * 30),
                            child: Text(
                              'Wine Management System',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 60.h),
                    
                    // Feature Cards
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textController.value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - _textController.value) * 40),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildFeatureCard(
                                    Icons.inventory_2,
                                    'Inventory',
                                    0,
                                  ),
                                  _buildFeatureCard(
                                    Icons.analytics,
                                    'Analytics',
                                    200,
                                  ),
                                  _buildFeatureCard(
                                    Icons.people,
                                    'Management',
                                    400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 60.h),
                    
                    // Progress Indicator
                    Padding(
                      padding: EdgeInsets.only(bottom: 50.h),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return Container(
                                width: 200.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 200.w * _progressController.value,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _progressController.value,
                                child: Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, int delay) {
    return Container(
      width: 70.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 600.ms).scale();
  }
}