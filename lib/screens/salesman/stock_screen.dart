import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import '../../models/stock_model.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockProvider>(context, listen: false).fetchStock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<StockProvider>(context, listen: false).fetchStock();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: ['All', ...AppConstants.productCategories]
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'All';
                    });
                  },
                ),
              ],
            ),
          ),
          // Stock List
          Expanded(
            child: Consumer<StockProvider>(
              builder: (context, stockProvider, child) {
                if (stockProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredStock = stockProvider.stock.where((stock) {
                  final matchesSearch = stock.productName
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  final matchesCategory = _selectedCategory == 'All' ||
                      stock.category == _selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredStock.isEmpty) {
                  return const Center(
                    child: Text('No stock items found'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredStock.length,
                  itemBuilder: (context, index) {
                    final stock = filteredStock[index];
                    return _buildStockCard(stock);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(StockModel stock) {
    final isLowStock = stock.closingStock < 10;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          stock.productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${stock.category}'),
            Text('Unit Price: ${AppConstants.currencySymbol}${stock.unitPrice}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${stock.closingStock}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLowStock ? Colors.red : Colors.green,
              ),
            ),
            Text(
              'In Stock',
              style: TextStyle(
                fontSize: 12,
                color: isLowStock ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        onTap: () {
          _showStockDetails(stock);
        },
      ),
    );
  }

  void _showStockDetails(StockModel stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stock.productName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${stock.category}'),
            Text('Unit Price: ${AppConstants.currencySymbol}${stock.unitPrice}'),
            const SizedBox(height: 16),
            Text('Opening Stock: ${stock.openingStock}'),
            Text('Purchases: ${stock.purchase}'),
            Text('Sales: ${stock.sale}'),
            Text('Closing Stock: ${stock.closingStock}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
