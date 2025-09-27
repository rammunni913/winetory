# Wine TorY Management System

A comprehensive Flutter application for wine shop management with role-based access control, inventory management, sales tracking, and reporting features.

## Features

### 🔐 Authentication & Authorization
- Role-based access control (Super Admin, Admin, Salesman)
- Secure login with credential management
- First-login credential change for Super Admin
- Session management and auto-logout

### 🏪 Shop Management
- Multi-shop support
- Shop creation, editing, and deactivation
- Shop-specific inventory and sales tracking
- Shop assignment to salesmen

### 👥 User Management
- User creation and role assignment
- Admin and Salesman management
- User profile management
- Permission-based access control

### 📦 Product & Inventory Management
- Product catalog with categories
- Rate list management
- Stock tracking (opening, purchases, transfers, closing)
- Auto-calculation of closing stock
- Product-wise inventory reports

### 💰 Sales Management
- Sales transaction recording
- Commission calculation
- Sales reports per shop and salesman
- Sales analytics and trends
- Receipt generation

### 💸 Expense Management
- Dukaan Kharcha (Shop Expenses)
- Commission Kharcha (Commission Expenses)
- Expense categorization and tracking
- Profit & Loss calculations
- Expense reports and analytics

### 📊 Reporting & Analytics
- Comprehensive sales reports
- Expense analysis
- Profit & Loss statements
- Stock reports
- User performance metrics
- Interactive charts and graphs

### 🔔 Notifications
- Push notifications for duty assignments
- Real-time updates
- Notification history
- Custom notification management

### 📱 Modern UI/UX
- Beautiful and animated interface
- Responsive design
- Dark/Light theme support
- Intuitive navigation
- Smooth animations and transitions

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Realtime Database
  - Firebase Cloud Messaging
  - Firebase Storage
- **State Management**: Provider
- **UI Libraries**: 
  - Google Fonts
  - Flutter Animate
  - Flutter SVG
  - FL Chart
- **Utilities**: 
  - Shared Preferences
  - Intl
  - UUID
  - URL Launcher
  - Image Picker
  - Cached Network Image
  - Printing & PDF

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── shop_model.dart
│   ├── product_model.dart
│   ├── stock_model.dart
│   ├── sales_model.dart
│   ├── expense_model.dart
│   └── assignment_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── shop_provider.dart
│   ├── product_provider.dart
│   ├── stock_provider.dart
│   ├── sales_provider.dart
│   ├── expense_provider.dart
│   └── notification_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── auth/                  # Authentication screens
│   ├── super_admin/          # Super Admin screens
│   ├── admin/                 # Admin screens
│   └── salesman/             # Salesman screens
├── utils/                    # Utilities
│   ├── constants.dart
│   ├── theme.dart
│   ├── validators.dart
│   └── helpers.dart
└── firebase_options.dart     # Firebase configuration
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Firebase project
- Android Studio / VS Code
- Git

### 1. Clone the Repository
```bash
git clone <repository-url>
cd wine-tory-management
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
1. Create a new Firebase project
2. Enable Authentication, Firestore, Realtime Database, Cloud Messaging, and Storage
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 4. Configure Firebase Rules
Deploy the security rules:
```bash
firebase deploy --only firestore:rules
firebase deploy --only database
firebase deploy --only storage
```

### 5. Run the Application
```bash
flutter run
```

## Default Credentials

- **Super Admin Mobile**: 1234567890
- **Super Admin Password**: admin123

> **Important**: Change these credentials on first login for security.

## User Roles & Permissions

### Super Admin
- Full system access
- Shop management
- User management
- System configuration
- All reports and analytics

### Admin
- Shop-specific management
- Product and inventory management
- Sales and expense tracking
- Salesman assignment
- Shop-level reports

### Salesman
- Assigned shop access only
- Sales recording
- Expense tracking
- Personal reports
- Assignment notifications

## Key Features Implementation

### 1. Authentication Flow
- Secure login with Firebase Authentication
- Role-based redirection
- Session management
- First-login credential change

### 2. Inventory Management
- Real-time stock tracking
- Auto-calculation of closing stock
- Stock transfer between shops
- Low stock alerts

### 3. Sales Tracking
- Commission calculation
- Sales analytics
- Performance tracking
- Receipt generation

### 4. Reporting System
- Interactive charts (FL Chart)
- Export functionality (PDF)
- Real-time data updates
- Custom date ranges

### 5. Push Notifications
- Firebase Cloud Messaging
- Duty assignment notifications
- Real-time updates
- Notification history

## Security Features

- Firebase Security Rules
- Role-based access control
- Data validation
- Secure file uploads
- Session management
- Input sanitization

## Performance Optimizations

- Lazy loading
- Image caching
- Data pagination
- Efficient state management
- Optimized queries

## Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

## Changelog

### Version 1.0.0
- Initial release
- Complete role-based management system
- Firebase integration
- Modern UI/UX
- Comprehensive reporting
- Push notifications
- Multi-shop support

---

**Wine TorY Management System** - Streamlining wine shop operations with modern technology.
