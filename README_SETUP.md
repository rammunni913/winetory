# Wine TorY Management System - Quick Setup Guide

## 🚀 Quick Start (Automated)

### Option 1: Automated Setup
1. **Run the setup script** (as Administrator):
   ```cmd
   setup_flutter.bat
   ```
2. **Restart your terminal**
3. **Run the app**:
   ```cmd
   run_app.bat
   ```

### Option 2: Manual Setup
1. **Download Flutter**: https://flutter.dev/docs/get-started/install/windows
2. **Extract to**: `C:\flutter`
3. **Add to PATH**: `C:\flutter\bin`
4. **Restart terminal**
5. **Run commands**:
   ```cmd
   flutter pub get
   flutter run
   ```

## 🔥 Firebase Setup (Already Complete!)

✅ **Firebase Project**: `wine-tory-management` created  
✅ **Firestore Rules**: Deployed  
✅ **Firestore Indexes**: Deployed  
✅ **Authentication**: Ready  
✅ **One-time Super Admin Registration**: Implemented  

## 📱 App Features Ready

### 🔐 Authentication
- **One-time Super Admin Registration** - First user becomes Super Admin
- **Role-based Access Control** - Super Admin, Admin, Salesman
- **Secure Login System** - Firebase Authentication

### 🏪 Management Features
- **Shop Management** - Create, edit, deactivate shops
- **User Management** - Admin, Salesman, Accountant roles
- **Product Catalog** - Categories, rate lists, inventory
- **Stock Management** - Opening, purchases, transfers, closing
- **Sales Tracking** - Commission calculation, reports
- **Expense Management** - Dukaan Kharcha, Commission Kharcha
- **Reporting** - Analytics, charts, PDF export

### 🎨 UI/UX Features
- **Beautiful Animated Interface** - Flutter Animate
- **Modern Material Design** - Material 3
- **Responsive Design** - All screen sizes
- **Dark/Light Theme** - User preference
- **Smooth Animations** - Professional feel

## 🚀 Running the App

### First Time Setup
1. **Install Flutter** (if not installed):
   ```cmd
   setup_flutter.bat
   ```

2. **Run the app**:
   ```cmd
   run_app.bat
   ```

### Manual Commands
```cmd
# Get dependencies
flutter pub get

# Run on Windows
flutter run -d windows

# Run on Chrome (web)
flutter run -d chrome

# Run on any available device
flutter run
```

## 🔧 Troubleshooting

### Flutter Not Found
- Run `setup_flutter.bat` as Administrator
- Restart terminal after installation
- Check PATH environment variable

### Dependencies Issues
```cmd
flutter clean
flutter pub get
flutter pub upgrade
```

### Firebase Issues
- Check internet connection
- Verify Firebase project is active
- Check Firebase console for service status

## 📋 Default Credentials

**Super Admin (First Registration)**:
- Mobile: Your choice (first registration)
- Password: Your choice (first registration)

**After Super Admin Created**:
- Mobile: 1234567890
- Password: admin123

## 🎯 Next Steps After Running

1. **Register First Super Admin** - Use the registration option
2. **Login with Super Admin** - Access full system
3. **Create Shops** - Add your wine shops
4. **Add Users** - Create Admin and Salesman accounts
5. **Setup Products** - Add wine products and categories
6. **Start Managing** - Begin sales and expense tracking

## 📞 Support

If you encounter any issues:
1. Check Flutter installation: `flutter doctor`
2. Check Firebase connection in console
3. Verify all dependencies: `flutter pub deps`
4. Check Firebase rules deployment status

---

**Wine TorY Management System** - Ready to streamline your wine shop operations! 🍷
