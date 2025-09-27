import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? product;
  
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityValueController = TextEditingController();
  final _unitPriceController = TextEditingController();

  String _selectedCategory = AppConstants.productCategories.first;
  String _selectedSubCategory = '';
  String _selectedSize = AppConstants.bottleSizes.first;
  String _selectedQuantityType = AppConstants.quantityTypes.first;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.product != null;
    if (_isEditMode) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _quantityValueController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _populateFields() {
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _brandController.text = widget.product!.brand;
      _descriptionController.text = widget.product!.description ?? '';
      _quantityValueController.text = widget.product!.quantityValue.toString();
      _unitPriceController.text = widget.product!.unitPrice.toString();
      _selectedCategory = widget.product!.category;
      _selectedSubCategory = widget.product!.subCategory;
      _selectedSize = widget.product!.size;
      _selectedQuantityType = widget.product!.quantityType;
    }
  }

  List<String> get _subCategories {
    switch (_selectedCategory) {
      case 'English Liquor':
        return AppConstants.englishLiquorSubcategories;
      case 'Desi Liquor':
        return AppConstants.desiLiquorSubcategories;
      case 'Beer':
        return AppConstants.beerSubcategories;
      default:
        return [];
    }
  }

  List<String> get _sizes {
    switch (_selectedCategory) {
      case 'English Liquor':
        return AppConstants.bottleSizes;
      case 'Desi Liquor':
        return AppConstants.bottleSizes;
      case 'Beer':
        return [...AppConstants.bottleSizes, ...AppConstants.canSizes];
      default:
        return AppConstants.bottleSizes;
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
      
      // Calculate total price
      int quantityValue = int.parse(_quantityValueController.text.trim());
      double unitPrice = double.parse(_unitPriceController.text.trim());
      double totalPrice = quantityValue * unitPrice;
      
      ProductModel product = ProductModel(
        id: _isEditMode ? widget.product!.id : const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        subCategory: _selectedSubCategory,
        brand: _brandController.text.trim(),
        size: _selectedSize,
        quantityType: _selectedQuantityType,
        quantityValue: quantityValue,
        unitPrice: unitPrice,
        totalPrice: totalPrice,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        isActive: true,
        createdAt: _isEditMode ? widget.product!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (_isEditMode) {
        success = await productProvider.updateProduct(product);
      } else {
        success = await productProvider.createProduct(product);
      }
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Product updated successfully' : 'Product added successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(productProvider.errorMessage ?? 'Failed to save product'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product' : 'Add New Product'),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return TextButton(
                onPressed: productProvider.isLoading ? null : _saveProduct,
                child: productProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isEditMode ? 'Update' : 'Save',
                        style: const TextStyle(
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
        child: Form(
          key: _formKey,
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
                      _isEditMode ? Icons.edit : Icons.add_box,
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
                      _isEditMode ? 'Edit Product' : 'Add New Product',
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
                      _isEditMode ? 'Update product information' : 'Enter product details to add to inventory',
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
              
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  prefixIcon: Icon(Icons.inventory),
                  hintText: 'Enter product name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Brand
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand *',
                  prefixIcon: Icon(Icons.branding_watermark),
                  hintText: 'Enter brand name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter brand name';
                  }
                  return null;
                },
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: AppConstants.productCategories.map((category) => 
                  DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _selectedSubCategory = _subCategories.isNotEmpty ? _subCategories.first : '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Sub Category
              if (_subCategories.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedSubCategory.isNotEmpty ? _selectedSubCategory : _subCategories.first,
                  decoration: const InputDecoration(
                    labelText: 'Sub Category *',
                    prefixIcon: Icon(Icons.subdirectory_arrow_right),
                  ),
                  items: _subCategories.map((subCategory) => 
                    DropdownMenuItem(
                      value: subCategory,
                      child: Text(subCategory),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select sub category';
                    }
                    return null;
                  },
                )
                    .animate(delay: 1200.ms)
                    .fadeIn(duration: 600.ms)
                    .slideX(begin: -0.3, end: 0),
              
              if (_subCategories.isNotEmpty) const SizedBox(height: 20),
              
              // Size
              DropdownButtonFormField<String>(
                value: _selectedSize,
                decoration: const InputDecoration(
                  labelText: 'Size *',
                  prefixIcon: Icon(Icons.straighten),
                ),
                items: _sizes.map((size) => 
                  DropdownMenuItem(
                    value: size,
                    child: Text(size),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select size';
                  }
                  return null;
                },
              )
                  .animate(delay: 1400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Quantity Type
              DropdownButtonFormField<String>(
                value: _selectedQuantityType,
                decoration: const InputDecoration(
                  labelText: 'Quantity Type *',
                  prefixIcon: Icon(Icons.inventory),
                ),
                items: AppConstants.quantityTypes.map((type) => 
                  DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedQuantityType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select quantity type';
                  }
                  return null;
                },
              )
                  .animate(delay: 1600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Quantity Value
              TextFormField(
                controller: _quantityValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity Value *',
                  prefixIcon: Icon(Icons.numbers),
                  hintText: 'Enter quantity',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter quantity value';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              )
                  .animate(delay: 1800.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Unit Price
              TextFormField(
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Unit Price *',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Enter unit price',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter unit price';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              )
                  .animate(delay: 2000.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 20),
              
              // Description (Optional)
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Enter product description',
                ),
              )
                  .animate(delay: 2200.ms)
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: -0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Save Button
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return ElevatedButton(
                    onPressed: productProvider.isLoading ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: productProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isEditMode ? 'Update Product' : 'Add Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              )
                  .animate(delay: 2400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              // Auto Calculation Info
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
                      Icons.calculate,
                      color: AppTheme.infoColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Total price will be calculated automatically (Quantity × Unit Price)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 2600.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
