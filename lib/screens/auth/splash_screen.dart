
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../providers/auth_provider.dart';
import '../super_admin/super_admin_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../salesman/salesman_dashboard.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isLoggedIn = await authProvider.checkAuthStatus();

    FlutterNativeSplash.remove();

    if (mounted) {
      if (isLoggedIn) {
        String role = authProvider.currentUser!.role;
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
            dashboard = const LoginScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dashboard),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
