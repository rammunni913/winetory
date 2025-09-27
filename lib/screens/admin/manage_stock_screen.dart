import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/stock_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/shop_provider.dart';
import '../../models/stock_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import 'add_stock_transaction_screen.dart';

class ManageStockScreen extends StatefulWidget {
  const ManageStockScreen({super.key});

  @override
  State<ManageStockScreen> createState() => _ManageStockScreenState();
}

class _ManageStockScreenState extends State<ManageStockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedShop = 'All';
  String _selectedCategory = 'All';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<StockProvider>(context, listen: false).fetchStock(),
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stock'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'English Liquor', icon: Icon(Icons.local_bar)),
            Tab(text: 'Desi Liquor', icon: Icon(Icons.wine_bar)),
            Tab(text: 'Beer', icon: Icon(Icons.sports_bar)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCategoryTab('English Liquor'),
          _buildCategoryTab('Desi Liquor'),
          _buildCategoryTab('Beer'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStockTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock Overview',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.3, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStockMetric(
                          context,
                          'Total Items',
                          '${stockProvider.stock.fold(0, (sum, s) => sum + s.closingStock)}',
                          Icons.inventory,
                        ),
                        _buildStockMetric(
                          context,
                          'Total Value',
                          '₹${stockProvider.stock.fold(0.0, (sum, s) => sum + s.totalValue).toStringAsFixed(0)}',
                          Icons.account_balance_wallet,
                        ),
                        _buildStockMetric(
                          context,
                          'Categories',
                          '${stockProvider.stock.map((s) => s.category).toSet().length}',
                          Icons.category,
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 24),
              
              // Stock by Category
              Text(
                'Stock by Category',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 16),
              
              ...AppConstants.productCategories.map((category) {
                var categoryStock = stockProvider.getStockByCategory(category);
                return _buildCategoryStockCard(context, category, categoryStock);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTab(String category) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, child) {
        List<StockModel> categoryStock = stockProvider.getStockByCategory(category);
        
        if (categoryStock.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 80,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No stock found for $category',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add stock transactions to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryStock.length,
            itemBuilder: (context, index) {
              StockModel stock = categoryStock[index];
              return _buildStockCard(context, stock, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildStockCard(BuildContext context, StockModel stock, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(stock.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(stock.category),
                    color: _getCategoryColor(stock.category),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.productName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stock.category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${stock.totalValue.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Stock Details
            Row(
              children: [
                Expanded(
                  child: _buildStockDetail(
                    context,
                    'Opening',
                    stock.openingStock.toString(),
                    AppTheme.infoColor,
                  ),
                ),
                Expanded(
                  child: _buildStockDetail(
                    context,
                    'Purchase',
                    stock.purchase.toString(),
                    AppTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _buildStockDetail(
                    context,
                    'Sent',
                    stock.sent.toString(),
                    AppTheme.warningColor,
                  ),
                ),
                Expanded(
                  child: _buildStockDetail(
                    context,
                    'Sale',
                    stock.sale.toString(),
                    AppTheme.errorColor,
                  ),
                ),
                Expanded(
                  child: _buildStockDetail(
                    context,
                    'Closing',
                    stock.closingStock.toString(),
                    AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unit Price: ₹${stock.unitPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  'Date: ${stock.date.day}/${stock.date.month}/${stock.date.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3, end: 0);
  }

  Widget _buildStockDetail(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryStockCard(BuildContext context, String category, List<StockModel> stock) {
    double totalValue = stock.fold(0.0, (sum, s) => sum + s.totalValue);
    int totalItems = stock.fold(0, (sum, s) => sum + s.closingStock);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: _getCategoryColor(category),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Items: $totalItems',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${totalValue.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getCategoryColor(category),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMetric(BuildContext context, String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'English Liquor':
        return Icons.local_bar;
      case 'Desi Liquor':
        return Icons.wine_bar;
      case 'Beer':
        return Icons.sports_bar;
      default:
        return Icons.inventory;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'English Liquor':
        return AppTheme.primaryColor;
      case 'Desi Liquor':
        return AppTheme.warningColor;
      case 'Beer':
        return AppTheme.infoColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<ShopProvider>(
              builder: (context, shopProvider, child) {
                return DropdownButtonFormField<String>(
                  value: _selectedShop,
                  decoration: const InputDecoration(
                    labelText: 'Shop',
                  ),
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All Shops')),
                    ...shopProvider.getActiveShops().map((shop) => 
                      DropdownMenuItem(
                        value: shop.id,
                        child: Text(shop.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedShop = value!;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: [
                const DropdownMenuItem(value: 'All', child: Text('All Categories')),
                ...AppConstants.productCategories.map((category) => 
                  DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadData();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
