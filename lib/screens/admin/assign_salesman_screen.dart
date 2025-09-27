import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/assignment_model.dart';
import '../../models/user_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class AssignSalesmanScreen extends StatefulWidget {
  const AssignSalesmanScreen({super.key});

  @override
  State<AssignSalesmanScreen> createState() => _AssignSalesmanScreenState();
}

class _AssignSalesmanScreenState extends State<AssignSalesmanScreen> {
  String? _selectedShopId;
  String? _selectedSalesmanId;
  DateTime _selectedDate = DateTime.now();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
      Provider.of<AuthProvider>(context, listen: false).getUsersByRole(AppConstants.salesmanRole),
    ]);
  }

  Future<void> _assignSalesman() async {
    if (_selectedShopId == null || _selectedSalesmanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select shop and salesman'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    var shop = shopProvider.getShopById(_selectedShopId!);
    var salesman = await authProvider.getUserById(_selectedSalesmanId!);

    if (shop == null || salesman == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop or salesman not found'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Create assignment
    AssignmentModel assignment = AssignmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      salesmanId: _selectedSalesmanId!,
      salesmanName: salesman.name,
      shopId: _selectedShopId!,
      shopName: shop.name,
      shopContact: shop.contact,
      assignmentDate: _selectedDate,
      status: 'assigned',
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Send notification
    await notificationProvider.sendAssignmentNotification(assignment);

    // Assign salesman to shop
    await shopProvider.assignSalesmanToShop(_selectedShopId!, _selectedSalesmanId!, salesman.name);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Salesman assigned successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Reset form
      setState(() {
        _selectedShopId = null;
        _selectedSalesmanId = null;
        _notesController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Salesman'),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, child) {
              return TextButton(
                onPressed: notificationProvider.isLoading ? null : _assignSalesman,
                child: notificationProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Assign',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.people,
                    size: 48,
                    color: Colors.white,
                  )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Assign Salesman',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Assign salesmen to shops for duty',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 32),
            
            // Shop Selection
            Consumer<ShopProvider>(
              builder: (context, shopProvider, child) {
                return DropdownButtonFormField<String>(
                  value: _selectedShopId,
                  decoration: const InputDecoration(
                    labelText: 'Select Shop *',
                    prefixIcon: Icon(Icons.store),
                  ),
                  items: shopProvider.getActiveShops().map((shop) => 
                    DropdownMenuItem(
                      value: shop.id,
                      child: Text(shop.name),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedShopId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select shop';
                    }
                    return null;
                  },
                );
              },
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 20),
            
            // Salesman Selection
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return FutureBuilder<List<UserModel>>(
                  future: authProvider.getUsersByRole(AppConstants.salesmanRole),
                  builder: (context, snapshot) {
                    final salesmen = snapshot.data ?? <UserModel>[];
                    return DropdownButtonFormField<String>(
                  value: _selectedSalesmanId,
                  decoration: const InputDecoration(
                    labelText: 'Select Salesman *',
                    prefixIcon: Icon(Icons.person),
                  ),
                      items: salesmen.map((salesman) => 
                        DropdownMenuItem<String>(
                          value: salesman.id,
                          child: Text(salesman.name),
                        ),
                      ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSalesmanId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select salesman';
                    }
                    return null;
                  },
                    );
                  },
                );
              },
            )
                .animate(delay: 800.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 20),
            
            // Assignment Date
            InkWell(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Assignment Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            )
                .animate(delay: 1000.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 20),
            
            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                prefixIcon: Icon(Icons.note),
                hintText: 'Enter any additional notes for the assignment',
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.3, end: 0),
            
            const SizedBox(height: 32),
            
            // Assign Button
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return ElevatedButton(
                  onPressed: notificationProvider.isLoading ? null : _assignSalesman,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: notificationProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Assign Salesman',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            )
                .animate(delay: 1400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 16),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.infoColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'The salesman will receive a push notification about the assignment with shop details and contact information.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: 1600.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
