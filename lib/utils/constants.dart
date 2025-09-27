class AppConstants {
  // App Information
  static const String appName = 'Wine TorY Management System';
  static const String appVersion = '1.0.0';
  
  // Default Credentials
  static const String defaultSuperAdminMobile = '1234567890';
  static const String defaultSuperAdminPassword = 'admin123';
  
  // User Roles
  static const String superAdminRole = 'super_admin';
  static const String adminRole = 'admin';
  static const String salesmanRole = 'salesman';
  static const String userRoleSuperAdmin = 'super_admin';
  static const String userRoleAdmin = 'admin';
  static const String userRoleSalesman = 'salesman';
  static const String userRoleAccountant = 'accountant';
  
  // Expense Types
  static const String dukaanExpense = 'Dukaan Kharcha Khata';
  static const String commissionExpense = 'Commission Kharcha Khata';
  
  // Stock Transaction Types
  static const String stockOpening = 'opening';
  static const String stockPurchase = 'purchase';
  static const String stockTransfer = 'transfer';
  static const String stockClosing = 'closing';
  
  // Sales Status
  static const String salesPending = 'pending';
  static const String salesCompleted = 'completed';
  static const String salesCancelled = 'cancelled';
  
  // Notification Types
  static const String notificationAssignment = 'assignment';
  static const String notificationReminder = 'reminder';
  static const String notificationAlert = 'alert';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String shopsCollection = 'shops';
  static const String productsCollection = 'products';
  static const String stockCollection = 'stock';
  static const String salesCollection = 'sales';
  static const String expensesCollection = 'expenses';
  static const String assignmentsCollection = 'assignments';
  static const String notificationsCollection = 'notifications';
  
  // Firebase Realtime Database Paths
  static const String usersPath = 'users';
  static const String shopsPath = 'shops';
  static const String productsPath = 'products';
  static const String stockPath = 'stock';
  static const String salesPath = 'sales';
  static const String expensesPath = 'expenses';
  static const String assignmentsPath = 'assignments';
  static const String notificationsPath = 'notifications';
  
  // Shared Preferences Keys
  static const String isFirstLogin = 'is_first_login';
  static const String userRole = 'user_role';
  static const String userId = 'user_id';
  static const String shopId = 'shop_id';
  static const String fcmToken = 'fcm_token';
  
  // Animation Durations
  static const int shortAnimationDuration = 300;
  static const int mediumAnimationDuration = 600;
  static const int longAnimationDuration = 900;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minDescriptionLength = 5;
  static const int maxDescriptionLength = 500;
  
  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String fullDateTimeFormat = 'dd MMM yyyy, HH:mm';
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
  
  // API Endpoints (if using REST API)
  static const String baseUrl = 'https://api.winetory.com';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String shopsEndpoint = '/shops';
  static const String productsEndpoint = '/products';
  static const String stockEndpoint = '/stock';
  static const String salesEndpoint = '/sales';
  static const String expensesEndpoint = '/expenses';
  static const String reportsEndpoint = '/reports';
  static const String notificationsEndpoint = '/notifications';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String permissionError = 'You do not have permission to perform this action.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logout successful';
  static const String saveSuccess = 'Saved successfully';
  static const String updateSuccess = 'Updated successfully';
  static const String deleteSuccess = 'Deleted successfully';
  static const String sendSuccess = 'Sent successfully';
  
  // Confirmation Messages
  static const String confirmDelete = 'Are you sure you want to delete this item?';
  static const String confirmLogout = 'Are you sure you want to logout?';
  static const String confirmSave = 'Are you sure you want to save these changes?';
  
  // Placeholder Text
  static const String searchHint = 'Search...';
  static const String nameHint = 'Enter name';
  static const String mobileHint = 'Enter mobile number';
  static const String passwordHint = 'Enter password';
  static const String emailHint = 'Enter email';
  static const String amountHint = 'Enter amount';
  static const String quantityHint = 'Enter quantity';
  static const String rateHint = 'Enter rate';
  static const String descriptionHint = 'Enter description';
  static const String shopNameHint = 'Enter shop name';
  static const String productNameHint = 'Enter product name';
  
  // Button Text
  static const String saveButton = 'Save';
  static const String updateButton = 'Update';
  static const String deleteButton = 'Delete';
  static const String cancelButton = 'Cancel';
  static const String confirmButton = 'Confirm';
  static const String loginButton = 'Login';
  static const String logoutButton = 'Logout';
  static const String addButton = 'Add';
  static const String editButton = 'Edit';
  static const String viewButton = 'View';
  static const String sendButton = 'Send';
  static const String refreshButton = 'Refresh';
  static const String backButton = 'Back';
  static const String nextButton = 'Next';
  static const String previousButton = 'Previous';
  static const String submitButton = 'Submit';
  static const String resetButton = 'Reset';
  static const String clearButton = 'Clear';
  static const String selectButton = 'Select';
  static const String chooseButton = 'Choose';
  static const String browseButton = 'Browse';
  static const String uploadButton = 'Upload';
  static const String downloadButton = 'Download';
  static const String printButton = 'Print';
  static const String shareButton = 'Share';
  static const String copyButton = 'Copy';
  static const String pasteButton = 'Paste';
  static const String cutButton = 'Cut';
  static const String undoButton = 'Undo';
  static const String redoButton = 'Redo';
  
  // Tab Labels
  static const String allTab = 'All';
  static const String pendingTab = 'Pending';
  static const String completedTab = 'Completed';
  static const String cancelledTab = 'Cancelled';
  static const String todayTab = 'Today';
  static const String weekTab = 'Week';
  static const String monthTab = 'Month';
  static const String yearTab = 'Year';
  
  // Status Labels
  static const String activeStatus = 'Active';
  static const String inactiveStatus = 'Inactive';
  static const String pendingStatus = 'Pending';
  static const String completedStatus = 'Completed';
  static const String cancelledStatus = 'Cancelled';
  static const String approvedStatus = 'Approved';
  static const String rejectedStatus = 'Rejected';
  
  // Priority Levels
  static const String highPriority = 'High';
  static const String mediumPriority = 'Medium';
  static const String lowPriority = 'Low';
  
  // Sort Options
  static const String sortByName = 'Name';
  static const String sortByDate = 'Date';
  static const String sortByAmount = 'Amount';
  static const String sortByStatus = 'Status';
  static const String sortAscending = 'Ascending';
  static const String sortDescending = 'Descending';
  
  // Filter Options
  static const String filterAll = 'All';
  static const String filterToday = 'Today';
  static const String filterThisWeek = 'This Week';
  static const String filterThisMonth = 'This Month';
  static const String filterThisYear = 'This Year';
  static const String filterCustom = 'Custom';
  
  // Chart Types
  static const String lineChart = 'Line Chart';
  static const String barChart = 'Bar Chart';
  static const String pieChart = 'Pie Chart';
  static const String areaChart = 'Area Chart';
  
  // Report Types
  static const String salesReport = 'Sales Report';
  static const String expenseReport = 'Expense Report';
  static const String profitLossReport = 'Profit & Loss Report';
  static const String stockReport = 'Stock Report';
  static const String userReport = 'User Report';
  static const String shopReport = 'Shop Report';
  
  // Notification Channels
  static const String generalChannel = 'general';
  static const String assignmentChannel = 'assignment';
  static const String reminderChannel = 'reminder';
  static const String alertChannel = 'alert';
  
  // Permission Levels
  static const String readPermission = 'read';
  static const String writePermission = 'write';
  static const String deletePermission = 'delete';
  static const String adminPermission = 'admin';
  
  // Theme Modes
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';
  
  // Language Codes
  static const String englishLanguage = 'en';
  static const String hindiLanguage = 'hi';
  static const String gujaratiLanguage = 'gu';
  
  // Country Codes
  static const String indiaCode = '+91';
  static const String usCode = '+1';
  static const String ukCode = '+44';
  
  // Time Zones
  static const String istTimeZone = 'Asia/Kolkata';
  static const String utcTimeZone = 'UTC';
  static const String estTimeZone = 'America/New_York';
  
  // Storage Keys
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications';
  static const String biometricsKey = 'biometrics';
  static const String autoLoginKey = 'auto_login';
  
  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String shopsCacheKey = 'shops_cache';
  static const String productsCacheKey = 'products_cache';
  static const String stockCacheKey = 'stock_cache';
  static const String salesCacheKey = 'sales_cache';
  static const String expensesCacheKey = 'expenses_cache';
  
  // Database Versions
  static const int databaseVersion = 1;
  static const String databaseName = 'wine_tory.db';
  
  // Backup Settings
  static const String backupFrequency = 'daily';
  static const int maxBackups = 7;
  static const String backupLocation = 'backups';
  
  // Security Settings
  static const int maxLoginAttempts = 5;
  static const int lockoutDuration = 30; // minutes
  static const int sessionTimeout = 60; // minutes
  static const bool requireBiometrics = false;
  static const bool requirePin = false;
  
  // Performance Settings
  static const int imageQuality = 80;
  static const int thumbnailSize = 150;
  static const int maxImageSize = 1920;
  static const bool enableCaching = true;
  static const int cacheExpiry = 24; // hours
  
  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  static const bool enableOfflineMode = true;
  static const bool enableDarkMode = true;
  static const bool enableMultiLanguage = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;

  // Product Categories
  static const List<String> productCategories = [
    'English Liquor',
    'Desi Liquor', 
    'Beer',
    'Wine',
    'Other'
  ];

  // Subcategories
  static const List<String> englishLiquorSubcategories = [
    'Whiskey',
    'Vodka',
    'Rum',
    'Gin',
    'Brandy',
    'Other'
  ];

  static const List<String> desiLiquorSubcategories = [
    'Country Liquor',
    'IMFL',
    'Feni',
    'Arrack',
    'Other'
  ];

  static const List<String> beerSubcategories = [
    'Premium',
    'Regular',
    'Strong',
    'Mild',
    'Other'
  ];

  // Bottle Sizes
  static const List<String> bottleSizes = [
    '180ml',
    '375ml',
    '750ml',
    '1000ml',
    '1500ml'
  ];

  // Can Sizes
  static const List<String> canSizes = [
    '330ml',
    '500ml',
    '650ml'
  ];

  // Quantity Types
  static const List<String> quantityTypes = [
    'Bottles',
    'Cases',
    'Pieces',
    'Liters',
    'Cartons'
  ];

  // Report Types
  static const List<String> reportTypes = [
    'Sales Report',
    'Stock Report', 
    'Expense Report',
    'Profit & Loss Report',
    'User Performance Report'
  ];

  // Business Constants
  static const String shopCodePrefix = 'WS';
  static const String invoicePrefix = 'INV';
}