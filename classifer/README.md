# Smart Waste Segregation App

A comprehensive Flutter application designed to revolutionize waste management through technology-driven solutions and community engagement.

## 🌟 Features

### For Users
- **AI-Powered Waste Classification**: Upload photos of waste items to get instant classification (biodegradable, recyclable, hazardous)
- **Points System**: Earn points for correct waste segregation, lose points for incorrect segregation
- **Leaderboard**: Compete with other users and track your ranking
- **Tax Benefits**: Earn tax reductions based on your points (5% to 20% reduction)
- **Guidelines**: Access comprehensive waste segregation guidelines with do's and don'ts
- **Complaints & Reports**: Report littering and infrastructure issues with location and photos
- **Feedback System**: Provide reviews and suggestions for service improvement

### For Workers
- **Waste Verification**: Review user-uploaded waste items with + and - buttons
- **Real-time Feedback**: Approve or reject waste segregation and provide feedback
- **Point Management**: Award or deduct points based on segregation accuracy
- **User Information**: View user details and current points

### For Municipal Officers
- **User Management**: Add, remove, and manage user accounts
- **Worker Management**: Add, remove, and manage worker accounts
- **Analytics Dashboard**: View comprehensive statistics and area-wise performance
- **Complaint Management**: Review and respond to user complaints
- **Feedback Management**: Review and respond to user feedback
- **Tax Calculation**: Manage tax reductions based on user performance

## 🏗️ Architecture

### Models
- `Member`: User information, points, tax details
- `Worker`: Worker information and assigned areas
- `Officer`: Municipal officer credentials
- `WasteItem`: Waste classification data and verification status
- `Complaint`: User complaints with location and images
- `Feedback`: User feedback and ratings

### Database
- SQLite database with comprehensive tables for all entities
- Relationships between users, waste items, complaints, and feedback
- Analytics queries for performance tracking

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd classifer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Demo Credentials

### User Login
- **Username**: john.doe
- **Password**: password123

### Worker Login
- **Username**: ram.singh
- **Password**: password123

### Officer Login
- **Username**: ravi.kumar
- **Password**: password123

## 🎯 How It Works

### User Workflow
1. **Login/Register**: Create an account or login with existing credentials
2. **Upload Waste**: Take a photo or select from gallery to classify waste
3. **Get Classification**: AI provides instant classification (biodegradable/recyclable/hazardous)
4. **Worker Verification**: Workers review and approve/reject your segregation
5. **Earn Points**: Get points for correct segregation, lose points for incorrect
6. **Track Progress**: View your points, ranking, and tax benefits
7. **Report Issues**: Submit complaints and feedback

### Worker Workflow
1. **Login**: Access worker dashboard with credentials
2. **Review Waste**: View pending waste items uploaded by users
3. **Verify Segregation**: Use + button for correct, - button for incorrect
4. **Provide Feedback**: Add comments and award/deduct points
5. **Track Performance**: Monitor user compliance in assigned areas

### Officer Workflow
1. **Login**: Access administrative dashboard
2. **Manage Users**: Add/remove users, view performance
3. **Manage Workers**: Add/remove workers, assign areas
4. **View Analytics**: Monitor overall performance and statistics
5. **Handle Complaints**: Review and respond to user complaints
6. **Manage Feedback**: Review and respond to user feedback

## 🎨 UI/UX Features

- **Modern Design**: Clean, intuitive interface with Material Design 3
- **Color-coded Classification**: Green (biodegradable), Blue (recyclable), Red (hazardous)
- **Responsive Layout**: Works on various screen sizes
- **Loading States**: Smooth loading indicators and progress feedback
- **Error Handling**: User-friendly error messages and validation
- **Accessibility**: Support for screen readers and accessibility features

## 📊 Analytics & Reporting

### User Analytics
- Total waste items uploaded
- Correct vs incorrect segregation rates
- Points earned and ranking
- Tax reduction benefits

### Area Analytics
- Top performing areas by points
- Compliance rates by district
- Worker performance metrics
- Complaint resolution rates

## 🔧 Technical Stack

- **Frontend**: Flutter/Dart
- **Database**: SQLite with sqflite
- **Image Processing**: image_picker, camera
- **Location Services**: geolocator, geocoding
- **State Management**: Provider pattern
- **UI Components**: Material Design 3

## 📋 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.2
  path_provider: ^2.1.2
  path: ^1.9.0
  image_picker: ^1.0.7
  camera: ^0.10.5+9
  geolocator: ^11.0.0
  geocoding: ^2.1.1
  http: ^1.1.2
  shared_preferences: ^2.2.2
  provider: ^6.1.1
  intl: ^0.19.0
  flutter_staggered_grid_view: ^0.7.0
  permission_handler: ^11.2.0
```

## 🛠️ Development

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── login.dart               # Role selection screen
├── user_login.dart          # User authentication
├── worker_login.dart        # Worker authentication
├── login_officer_page.dart  # Officer authentication
├── user_dashboard.dart      # User main interface
├── worker_dashboard.dart    # Worker main interface
├── office_tabs.dart         # Officer main interface
├── guidelines_page.dart     # Waste segregation guidelines
├── leaderboard_page.dart    # User rankings and points
├── complaints_page.dart     # Complaint management
├── feedback_page.dart       # Feedback system
├── about_us_page.dart       # Team information
├── models/                  # Data models
│   ├── members_model.dart
│   ├── worker.dart
│   ├── officer.dart
│   ├── waste_item.dart
│   ├── complaint.dart
│   └── feedback.dart
└── db/                      # Database operations
    └── database_helper.dart
```

### Key Features Implementation

#### AI Waste Classification
- Simulated AI classification (replace with actual ML model)
- Image processing and storage
- Classification result display

#### Points System
- Real-time point calculation
- Database updates for user points
- Leaderboard ranking

#### Worker Verification
- Pending waste items queue
- Approval/rejection workflow
- Point awarding system

#### Analytics Dashboard
- SQL queries for statistics
- Area-wise performance tracking
- Real-time data updates

## 🚀 Future Enhancements

- **Real AI Integration**: Replace simulated classification with actual ML model
- **Push Notifications**: Real-time updates for users and workers
- **Offline Support**: Work without internet connection
- **Multi-language Support**: Support for multiple languages
- **Advanced Analytics**: Detailed reports and insights
- **Social Features**: Community challenges and competitions
- **QR Code Integration**: Quick waste identification
- **IoT Integration**: Smart bin connectivity

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

This project was developed by a team of 4 members. Update the About Us page with your team details.

## 📞 Support

For support and questions, please contact:
- Email: contact@smartwaste.com
- Phone: +91 98765 43210

---

**Smart Waste Segregation** - Together, we can make a difference! 🌱♻️
