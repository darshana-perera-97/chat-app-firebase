# WhatsApp Style Chat App - Flutter

A modern, responsive chat application built with Flutter that mimics WhatsApp's design and functionality.

## Features

- 🎨 **WhatsApp Theme**: Authentic WhatsApp colors and styling
- 📱 **Responsive Design**: Works perfectly on mobile, tablet, and desktop
- 🔐 **Authentication**: Login and signup screens with form validation
- 💬 **Real-time Chat**: Message bubbles with timestamps and read receipts
- ⌨️ **Typing Indicator**: Animated typing indicator
- 🌙 **Dark Theme**: Beautiful dark theme matching WhatsApp
- 📐 **Responsive Framework**: Adaptive layout for all screen sizes

## Screenshots

The app includes:
- Login/Signup screens with WhatsApp-style theming
- Chat interface with message bubbles
- Responsive design that adapts to different screen sizes
- Typing indicators and message timestamps

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Firebase project (for authentication and real-time messaging)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download configuration files:
     - For Android: `google-services.json` → `android/app/`
     - For iOS: `GoogleService-Info.plist` → `ios/Runner/`
     - For Web: Add config to `web/index.html`

4. **Update Firebase Configuration**
   - Update `lib/firebase_options.dart` with your Firebase project details
   - Or run `flutterfire configure` to auto-generate the configuration

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── theme/
│   ├── app_colors.dart      # WhatsApp color palette
│   └── app_theme.dart       # Theme configuration
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   └── chat/
│       └── chat_screen.dart
└── widgets/
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── message_bubble.dart
    └── typing_indicator.dart
```

## Dependencies

- `firebase_core`: Firebase initialization
- `firebase_auth`: User authentication
- `cloud_firestore`: Real-time database
- `responsive_framework`: Responsive design
- `provider`: State management
- `font_awesome_flutter`: Icons

## Features Implemented

### ✅ Completed
- WhatsApp theme colors and styling
- Responsive design with Bootstrap-like breakpoints
- Authentication screens (login/signup)
- Chat interface with message bubbles
- Typing indicator animation
- Custom form components
- Dark theme throughout

### 🚧 TODO (Next Steps)
- Firebase authentication integration
- Real-time messaging with Firestore
- User profile management
- Message status indicators
- File/image sharing
- Push notifications
- Group chat functionality

## Customization

### Colors
Edit `lib/theme/app_colors.dart` to customize the color scheme.

### Responsive Breakpoints
Modify `lib/theme/app_theme.dart` to adjust responsive breakpoints.

### Firebase Configuration
Update `lib/firebase_options.dart` with your Firebase project details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple screen sizes
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the GitHub repository.

---

**Note**: This is a demo application. For production use, ensure proper security rules are configured in Firebase and implement proper error handling.