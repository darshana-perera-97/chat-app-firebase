# Firebase Chat App

A real-time chat application built with HTML, CSS, and JavaScript using Firebase for authentication and database.

## Features

- 🔐 User authentication (signup/login)
- 💬 Real-time messaging
- 👤 User profiles with avatars
- 📱 Responsive design
- 🚀 Offline support with Firebase persistence
- 🎨 Modern UI with gradient design

## Prerequisites

- A Firebase project
- Basic knowledge of HTML, CSS, and JavaScript

## Setup Instructions

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or select an existing project
3. Follow the setup wizard

### 2. Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" authentication
5. Click "Save"

### 3. Enable Firestore Database

1. In your Firebase project, go to "Firestore Database" in the left sidebar
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location for your database
5. Click "Done"

### 4. Get Firebase Configuration

1. In your Firebase project, click the gear icon (⚙️) next to "Project Overview"
2. Select "Project settings"
3. Scroll down to "Your apps" section
4. Click the web icon (</>)
5. Register your app with a nickname
6. Copy the Firebase configuration object

### 5. Update Configuration

1. Open `config.js` in your project
2. Replace the placeholder values with your actual Firebase configuration:

```javascript
const firebaseConfig = {
    apiKey: "your-actual-api-key",
    authDomain: "your-project-id.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    messagingSenderId: "your-messaging-sender-id",
    appId: "your-app-id"
};
```

### 6. Set Firestore Rules

1. In Firestore Database, go to "Rules" tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read/write messages
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 7. Run the Application

1. Open `index.html` in a web browser
2. Or serve the files using a local server:
   - Using Python: `python -m http.server 8000`
   - Using Node.js: `npx serve .`
   - Using VS Code: Install "Live Server" extension

## Project Structure

```
chat-app-firebase/
├── index.html          # Main HTML file
├── styles.css          # CSS styling
├── config.js           # Firebase configuration
├── app.js             # Main application logic
└── README.md          # This file
```

## How It Works

### Authentication Flow
1. Users can sign up with email, password, and name
2. User data is stored in Firestore
3. Users can log in with their credentials
4. Authentication state is managed by Firebase Auth

### Chat Functionality
1. Messages are stored in Firestore 'messages' collection
2. Real-time updates using Firestore onSnapshot listener
3. Messages include user ID, name, text, and timestamp
4. UI automatically updates when new messages arrive

### Data Structure

**Users Collection:**
```javascript
{
  name: "User's Full Name",
  email: "user@example.com",
  createdAt: timestamp
}
```

**Messages Collection:**
```javascript
{
  text: "Message content",
  userId: "user-uid",
  userName: "User's Name",
  timestamp: timestamp
}
```

## Security Features

- Email/password authentication
- Firestore security rules
- User data isolation
- Input validation

## Browser Support

- Chrome (recommended)
- Firefox
- Safari
- Edge

## Troubleshooting

### Common Issues

1. **"Firebase is not defined" error**
   - Check if Firebase SDK scripts are loaded correctly
   - Verify internet connection

2. **Authentication not working**
   - Ensure Email/Password auth is enabled in Firebase
   - Check browser console for errors

3. **Messages not appearing**
   - Verify Firestore rules allow read/write
   - Check if database is created and accessible

4. **CORS errors**
   - Serve files from a local server instead of opening directly

### Debug Mode

Open browser console (F12) to see detailed error messages and logs.

## Customization

### Styling
- Modify `styles.css` to change colors, fonts, and layout
- Update gradient colors in CSS variables
- Adjust responsive breakpoints

### Features
- Add file upload functionality
- Implement user typing indicators
- Add message reactions
- Create private chat rooms

## Deployment

### Firebase Hosting (Recommended)
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Initialize: `firebase init hosting`
4. Deploy: `firebase deploy`

### Other Options
- GitHub Pages
- Netlify
- Vercel
- Any static hosting service

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues:
1. Check the troubleshooting section
2. Review Firebase documentation
3. Check browser console for errors
4. Ensure all setup steps are completed correctly



 apiKey: "AIzaSyDZWBs4wucLv22ri2PNzf_zFJ0dDTzJ1AE",
    authDomain: "chat-app-89d9f.firebaseapp.com",
    projectId: "chat-app-89d9f",
    storageBucket: "chat-app-89d9f.firebasestorage.app",
    messagingSenderId: "81201995663",
    appId: "1:81201995663:web:137a704673167edc0cf5fa",
    measurementId: "G-YJRTS5SLTZ"