import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/shop_provider.dart';
import '../../models/shop_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import 'add_shop_screen.dart';

class ManageShopsScreen extends StatefulWidget {
  const ManageShopsScreen({super.key});

  @override
  State<ManageShopsScreen> createState() => _ManageShopsScreenState();
}

class _ManageShopsScreenState extends State<ManageShopsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Shops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ShopProvider>(context, listen: false).fetchShops();
            },
          ),
        ],
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shopProvider, child) {
          if (shopProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (shopProvider.shops.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 80,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No shops found',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first shop to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await shopProvider.fetchShops();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: shopProvider.shops.length,
              itemBuilder: (context, index) {
                ShopModel shop = shopProvider.shops[index];
                return _buildShopCard(context, shop, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddShopScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Shop'),
      ),
    );
  }

  Widget _buildShopCard(BuildContext context, ShopModel shop, int index) {
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
          _showShopDetails(context, shop);
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
                      color: shop.isActive 
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.store,
                      color: shop.isActive 
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shop.shopCode,
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
                      color: shop.isActive 
                          ? AppTheme.successColor.withOpacity(0.1)
                          : AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      shop.isActive ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: shop.isActive 
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
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
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      shop.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    shop.contact,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              
              if (shop.assignedSalesmen != null && shop.assignedSalesmen!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${shop.assignedSalesmen!.length} salesmen assigned',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showShopDetails(context, shop);
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      _toggleShopStatus(context, shop);
                    },
                    icon: Icon(
                      shop.isActive ? Icons.pause : Icons.play_arrow,
                      size: 16,
                    ),
                    label: Text(shop.isActive ? 'Deactivate' : 'Activate'),
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

  void _showShopDetails(BuildContext context, ShopModel shop) {
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
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.store,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shop.shopCode,
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
                            color: shop.isActive 
                                ? AppTheme.successColor.withOpacity(0.1)
                                : AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            shop.isActive ? 'Active' : 'Inactive',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: shop.isActive 
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildDetailRow(
                      context,
                      'Address',
                      shop.address,
                      Icons.location_on,
                    ),
                    
                    _buildDetailRow(
                      context,
                      'Contact',
                      shop.contact,
                      Icons.phone,
                    ),
                    
                    if (shop.email != null)
                      _buildDetailRow(
                        context,
                        'Email',
                        shop.email!,
                        Icons.email,
                      ),
                    
                    if (shop.ownerName != null)
                      _buildDetailRow(
                        context,
                        'Owner',
                        shop.ownerName!,
                        Icons.person,
                      ),
                    
                    _buildDetailRow(
                      context,
                      'Created',
                      '${shop.createdAt.day}/${shop.createdAt.month}/${shop.createdAt.year}',
                      Icons.calendar_today,
                    ),
                    
                    if (shop.assignedSalesmen != null && shop.assignedSalesmen!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Assigned Salesmen',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...shop.assignedSalesmen!.map((salesmanId) => 
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                salesmanId,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  void _toggleShopStatus(BuildContext context, ShopModel shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shop.isActive ? 'Deactivate Shop' : 'Activate Shop'),
        content: Text(
          shop.isActive 
              ? 'Are you sure you want to deactivate ${shop.name}?'
              : 'Are you sure you want to activate ${shop.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (shop.isActive) {
                await Provider.of<ShopProvider>(context, listen: false).deactivateShop(shop.id);
              } else {
                // Activate shop logic here
                await Provider.of<ShopProvider>(context, listen: false).updateShop(
                  shop.copyWith(isActive: true),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: shop.isActive ? AppTheme.errorColor : AppTheme.successColor,
            ),
            child: Text(shop.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }
}
