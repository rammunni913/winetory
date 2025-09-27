class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateShopName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Shop name is required';
    }
    if (value.length < 2) {
      return 'Shop name must be at least 2 characters';
    }
    return null;
  }

  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product name is required';
    }
    if (value.length < 2) {
      return 'Product name must be at least 2 characters';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }
    return null;
  }

  static String? validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rate is required';
    }
    final rate = double.tryParse(value);
    if (rate == null) {
      return 'Please enter a valid rate';
    }
    if (rate <= 0) {
      return 'Rate must be greater than 0';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    if (value.length < 5) {
      return 'Description must be at least 5 characters';
    }
    return null;
  }
}
