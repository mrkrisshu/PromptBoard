# PromptBoard

A Flutter mobile app for browsing and managing AI prompts with Firebase backend.

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase CLI: `npm install -g firebase-tools`
- A Firebase project

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Firebase

```bash
# Login to Firebase
firebase login

# Configure Firebase for Flutter (this will generate firebase_options.dart)
flutterfire configure
```

Select your Firebase project and platforms (Android/iOS).

### 3. Setup Firebase Services

#### Enable Authentication
1. Go to Firebase Console → Authentication
2. Enable **Email/Password** provider
3. Enable **Anonymous** provider (optional, for guest users)

#### Setup Firestore
1. Go to Firebase Console → Firestore Database
2. Create database in production mode
3. Update security rules (see below)

#### Setup Storage
1. Go to Firebase Console → Storage
2. Create default bucket
3. Update security rules (see below)

#### Create Admin User
1. Go to Firebase Console → Authentication
2. Add user manually with email/password
3. Copy the user UID
4. Go to Firestore → users collection
5. Create document with user UID:
   ```json
   {
     "email": "admin@example.com",
     "role": "admin",
     "createdAt": (server timestamp),
     "updatedAt": (server timestamp)
   }
   ```

### 4. Deploy Security Rules

#### Firestore Rules (`firestore.rules`)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Prompts collection
    match /prompts/{promptId} {
      allow read: if true; // Public read
      allow create, update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

Deploy: `firebase deploy --only firestore:rules`

#### Storage Rules (`storage.rules`)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /prompts/{promptId}/{filename} {
      allow read: if true; // Public read
      allow write: if request.auth != null && 
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

Deploy: `firebase deploy --only storage:rules`

### 5. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Run the App

```bash
# Android
flutter run

# iOS
flutter run
```

## Seeding Sample Data

To populate the app with sample prompts:

1. Login as admin
2. Use the admin panel to create prompts manually, OR
3. Modify `lib/seed_data.dart` and call `SeedDataService().seedPrompts(userId)` from a temporary button

## Project Structure

```
lib/
├── core/               # Core app configuration
│   ├── providers.dart  # Riverpod providers
│   ├── router.dart     # Navigation
│   └── theme.dart      # App theme
├── models/             # Data models
├── services/           # Firebase services
├── repositories/       # Data access layer
├── providers/          # State management
├── screens/            # UI screens
│   ├── admin/          # Admin screens
│   ├── home_screen.dart
│   ├── prompt_detail_screen.dart
│   └── splash_screen.dart
└── widgets/            # Reusable widgets
```

## Features

### User Features
- Browse prompts with instant loading
- Search by text and tags
- Filter by tags
- View full prompt details
- Copy prompts to clipboard
- View source information
- Offline support

### Admin Features
- Secure login
- Create/edit/delete prompts
- Upload images or use URLs
- Manage tags and categories
- Mark prompts as featured

## Performance Optimizations

- **Firestore offline persistence** for instant loading
- **Hive local cache** for structured data storage
- **Image prefetching** on splash screen
- **cached_network_image** for efficient image loading
- Cache-first architecture with background sync

## Troubleshooting

### Build errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase connection issues
- Verify `firebase_options.dart` is generated correctly
- Check Firebase project settings
- Ensure all Firebase services are enabled

### Images not loading
- Check Storage rules allow public read
- Verify image URLs are accessible
- Check network connectivity

## License

This project is for educational/demonstration purposes.
