import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/expense_provider.dart';
import '../../utils/theme.dart';
import 'sales_screen.dart';
import 'expenses_screen.dart';
import 'stock_screen.dart';
import 'notifications_screen.dart';

class SalesmanDashboard extends StatefulWidget {
  const SalesmanDashboard({super.key});

  @override
  State<SalesmanDashboard> createState() => _SalesmanDashboardState();
}

class _SalesmanDashboardState extends State<SalesmanDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const SalesScreen(),
    const ExpensesScreen(),
    const StockScreen(),
    const NotificationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<SalesProvider>(context, listen: false).fetchSales(),
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salesman Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Salesman!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.3, end: 0),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Manage your sales and track your performance',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.3, end: 0),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 24),
            
            // Assignment Info
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.infoColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.assignment,
                            color: AppTheme.infoColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Today\'s Assignment',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        'Shop: [Shop Name]',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      )
                          .animate(delay: 600.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      Text(
                        'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      )
                          .animate(delay: 800.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                      
                      Text(
                        'Contact: [Shop Contact]',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      )
                          .animate(delay: 1000.ms)
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),
                    ],
                  ),
                );
              },
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 24),
            
            // Quick Stats
            Text(
              'Today\'s Performance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Consumer<SalesProvider>(
              builder: (context, salesProvider, child) {
                return Consumer<ExpenseProvider>(
                  builder: (context, expenseProvider, child) {
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          context,
                          'Sales Today',
                          '₹${salesProvider.getSalesSummary()['totalSales']?.toStringAsFixed(0) ?? '0'}',
                          Icons.trending_up,
                          AppTheme.successColor,
                          delay: 1400.ms,
                        ),
                        _buildStatCard(
                          context,
                          'Expenses Today',
                          '₹${expenseProvider.getExpenseSummary()['totalAmount']?.toStringAsFixed(0) ?? '0'}',
                          Icons.money_off,
                          AppTheme.errorColor,
                          delay: 1600.ms,
                        ),
                        _buildStatCard(
                          context,
                          'Sales Count',
                          salesProvider.getSalesSummary()['salesCount']?.toString() ?? '0',
                          Icons.receipt,
                          AppTheme.primaryColor,
                          delay: 1800.ms,
                        ),
                        _buildStatCard(
                          context,
                          'Commission',
                          '₹${salesProvider.getSalesSummary()['totalCommission']?.toStringAsFixed(0) ?? '0'}',
                          Icons.percent,
                          AppTheme.warningColor,
                          delay: 2000.ms,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(delay: 2200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Column(
              children: [
                _buildActionCard(
                  context,
                  'Record Sale',
                  'Add new sales transaction',
                  Icons.point_of_sale,
                  () {
                    // Navigate to sales tab
                  },
                  delay: 2400.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'Add Expense',
                  'Record shop or commission expenses',
                  Icons.money_off,
                  () {
                    // Navigate to expenses tab
                  },
                  delay: 2600.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'View Stock',
                  'Check available inventory',
                  Icons.inventory,
                  () {
                    // Navigate to stock tab
                  },
                  delay: 2800.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'Notifications',
                  'View assignment and other notifications',
                  Icons.notifications,
                  () {
                    // Navigate to notifications tab
                  },
                  delay: 3000.ms,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    Duration delay = Duration.zero,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Duration delay = Duration.zero,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3, end: 0);
  }
}
