import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/expense_provider.dart';
import '../../utils/theme.dart';
import 'manage_products_screen.dart';
import 'manage_stock_screen.dart';
import 'manage_sales_screen.dart';
import 'manage_expenses_screen.dart';
import 'assign_salesman_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const ManageProductsScreen(),
    const ManageStockScreen(),
    const ManageSalesScreen(),
    const ManageExpensesScreen(),
    const AssignSalesmanScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
      Provider.of<SalesProvider>(context, listen: false).fetchSales(),
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
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
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: 'Stock',
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
            icon: Icon(Icons.people),
            label: 'Assign',
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
        title: const Text('Admin Dashboard'),
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
                    'Welcome, Admin!',
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
                    'Manage your shop operations efficiently',
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
            
            // Quick Stats
            Text(
              'Quick Overview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Consumer<SalesProvider>(
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
                              'Total Products',
                              productProvider.products.length.toString(),
                              Icons.inventory,
                              AppTheme.primaryColor,
                              delay: 600.ms,
                            ),
                            _buildStatCard(
                              context,
                              'Total Sales',
                              '₹${salesProvider.getSalesSummary()['totalSales']?.toStringAsFixed(0) ?? '0'}',
                              Icons.trending_up,
                              AppTheme.successColor,
                              delay: 800.ms,
                            ),
                            _buildStatCard(
                              context,
                              'Total Expenses',
                              '₹${expenseProvider.getExpenseSummary()['totalAmount']?.toStringAsFixed(0) ?? '0'}',
                              Icons.money_off,
                              AppTheme.warningColor,
                              delay: 1000.ms,
                            ),
                            _buildStatCard(
                              context,
                              'Net Profit',
                              '₹${((salesProvider.getSalesSummary()['totalSales'] ?? 0) - (expenseProvider.getExpenseSummary()['totalAmount'] ?? 0)).toStringAsFixed(0)}',
                              Icons.account_balance_wallet,
                              AppTheme.infoColor,
                              delay: 1200.ms,
                            ),
                          ],
                        );
                      },
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
                .animate(delay: 1400.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 16),
            
            Column(
              children: [
                _buildActionCard(
                  context,
                  'Manage Products',
                  'Add, edit, or delete products',
                  Icons.inventory,
                  () {
                    // Navigate to products tab
                  },
                  delay: 1600.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'Manage Stock',
                  'Track opening, purchase, and closing stock',
                  Icons.warehouse,
                  () {
                    // Navigate to stock tab
                  },
                  delay: 1800.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'View Sales',
                  'Monitor sales transactions',
                  Icons.point_of_sale,
                  () {
                    // Navigate to sales tab
                  },
                  delay: 2000.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'Manage Expenses',
                  'Track shop and commission expenses',
                  Icons.money_off,
                  () {
                    // Navigate to expenses tab
                  },
                  delay: 2200.ms,
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  context,
                  'Assign Salesman',
                  'Assign salesmen to shops',
                  Icons.people,
                  () {
                    // Navigate to assign tab
                  },
                  delay: 2400.ms,
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
