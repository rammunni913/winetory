import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import 'add_product_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';

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
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Products', icon: Icon(Icons.inventory)),
            Tab(text: 'English Liquor', icon: Icon(Icons.local_bar)),
            Tab(text: 'Desi Liquor', icon: Icon(Icons.wine_bar)),
            Tab(text: 'Beer', icon: Icon(Icons.sports_bar)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All')),
                    ...AppConstants.productCategories.map((category) => 
                      DropdownMenuItem(value: category, child: Text(category)),
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
          ),
          
          // Products List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsList('All'),
                _buildProductsList('English Liquor'),
                _buildProductsList('Desi Liquor'),
                _buildProductsList('Beer'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildProductsList(String category) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<ProductModel> products = productProvider.products;
        
        // Filter by category
        if (category != 'All') {
          products = products.where((p) => p.category == category).toList();
        }
        
        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          products = products.where((p) => 
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.brand.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first product to get started',
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
            itemCount: products.length,
            itemBuilder: (context, index) {
              ProductModel product = products[index];
              return _buildProductCard(context, product, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, int index) {
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
      child: InkWell(
        onTap: () {
          _showProductDetails(context, product);
        },
        borderRadius: BorderRadius.circular(12),
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
                      color: _getCategoryColor(product.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(product.category),
                      color: _getCategoryColor(product.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.brand,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(product.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getCategoryColor(product.category),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.subCategory,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.straighten,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.size,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.inventory,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.quantityValue} ${product.quantityType}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '₹${product.unitPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ₹${product.totalPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _showProductDetails(context, product);
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          _editProduct(context, product);
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.3, end: 0);
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

  void _showProductDetails(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(product.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(product.category),
                            color: _getCategoryColor(product.category),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.brand,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(product.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getCategoryColor(product.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildDetailRow(
                      context,
                      'Sub Category',
                      product.subCategory,
                      Icons.category,
                    ),
                    
                    _buildDetailRow(
                      context,
                      'Size',
                      product.size,
                      Icons.straighten,
                    ),
                    
                    _buildDetailRow(
                      context,
                      'Quantity',
                      '${product.quantityValue} ${product.quantityType}',
                      Icons.inventory,
                    ),
                    
                    _buildDetailRow(
                      context,
                      'Unit Price',
                      '₹${product.unitPrice.toStringAsFixed(0)}',
                      Icons.attach_money,
                    ),
                    
                    _buildDetailRow(
                      context,
                      'Total Price',
                      '₹${product.totalPrice.toStringAsFixed(0)}',
                      Icons.account_balance_wallet,
                    ),
                    
                    if (product.description != null)
                      _buildDetailRow(
                        context,
                        'Description',
                        product.description!,
                        Icons.description,
                      ),
                    
                    _buildDetailRow(
                      context,
                      'Created',
                      '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(BuildContext context, ProductModel product) {
    // Navigate to edit product screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(product: product),
      ),
    );
  }
}
