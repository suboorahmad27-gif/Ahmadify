#!/usr/bin/env bash
set -e

ROOT_DIR="Ahmadify"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "Creating project structure in $(pwd)"

# .gitignore
cat > .gitignore <<'EOF'
/build/
/.dart_tool/
/.pub-cache/
/.packages
/.flutter-plugins
/.flutter-plugins-dependencies
/.idea/
/.vscode/
android/.gradle/
ios/Flutter/Flutter.framework
*.iml
*.ipr
*.iws
.DS_Store
.env
/functions/node_modules/
/functions/.firebase/
pubspec.lock
EOF

# README.md
cat > README.md <<'EOF'
# Ahmadify

A Flutter starter scaffold for Ahmadify — a sample app integrating Firebase and modular screens.

## Getting started

1. Install Flutter: https://flutter.dev/docs/get-started/install
2. Clone the repo and install dependencies:

   flutter pub get

3. Copy .env.example to .env and fill Firebase configuration values.
4. Initialize Firebase for Android/iOS as per Firebase docs.
5. Run the app:

   flutter run

## Features
- Firebase initialization helper
- Basic screen structure (auth, home, rent, services, materials, rules)
- Firebase Cloud Functions scaffold
- GitHub Actions Flutter CI
EOF

# .env.example
cat > .env.example <<'EOF'
# Firebase config example
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
FIREBASE_MEASUREMENT_ID=G-XXXXXXXXXX

# Google Maps
GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
EOF

# firebase rules
cat > firebase_rules.rules <<'EOF'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Basic rule: allow read/write only for authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
EOF

# pubspec.yaml
cat > pubspec.yaml <<'EOF'
name: ahmadify
description: Ahmadify Flutter scaffold
publish_to: 'none'
version: 0.0.1
environment:
  sdk: ">=2.18.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  flutter_dotenv: ^5.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/
EOF

# Android/iOS placeholders
mkdir -p android ios
touch android/.gitkeep ios/.gitkeep

# lib layout
mkdir -p lib/screens/auth lib/screens/rent lib/screens/services lib/screens/materials lib/screens/rules lib/services

# lib/main.dart
cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  runApp(const MyApp());
}
EOF

# lib/app.dart
cat > lib/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/firebase_service.dart';

class App {
  static Future<void> init() async {
    await FirebaseService.initialize();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmadify',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
EOF

# lib/screens/home_screen.dart
cat > lib/screens/home_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ahmadify')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SizedBox()),
              ),
              child: const Text('Rent List (placeholder)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SizedBox()),
              ),
              child: const Text('Services List (placeholder)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SizedBox()),
              ),
              child: const Text('Materials List (placeholder)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SizedBox()),
              ),
              child: const Text('Rules (placeholder)'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# lib/screens/auth/login_screen.dart
cat > lib/screens/auth/login_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  Future<void> _anonyLogin() async {
    setState(() => _loading = true);
    try {
      await FirebaseService.signInAnonymously();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: \$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _anonyLogin,
                child: const Text('Sign in anonymously'),
              ),
      ),
    );
  }
}
EOF

# other screen stubs
cat > lib/screens/rent/rent_list.dart <<'EOF'
import 'package:flutter/material.dart';

class RentList extends StatelessWidget {
  const RentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rent List')),
      body: const Center(child: Text('Rent items will be listed here')),
    );
  }
}
EOF

cat > lib/screens/services/services_list.dart <<'EOF'
import 'package:flutter/material.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: const Center(child: Text('Services will be listed here')),
    );
  }
}
EOF

cat > lib/screens/materials/materials_list.dart <<'EOF'
import 'package:flutter/material.dart';

class MaterialsList extends StatelessWidget {
  const MaterialsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materials')),
      body: const Center(child: Text('Materials will be listed here')),
    );
  }
}
EOF

cat > lib/screens/rules/rules_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rules')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Project rules or Firebase rules info can be shown here.'),
      ),
    );
  }
}
EOF

# services/firebase_service.dart
cat > lib/services/firebase_service.dart <<'EOF'
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future<UserCredential> signInAnonymously() async {
    return FirebaseAuth.instance.signInAnonymously();
  }
}
EOF

# Functions folder
mkdir -p functions
cat > functions/package.json <<'EOF'
{
  "name": "ahmadify-functions",
  "version": "0.1.0",
  "dependencies": {
    "firebase-admin": "^11.0.0",
    "firebase-functions": "^4.0.0"
  },
  "engines": {
    "node": "18"
  }
}
EOF

cat > functions/index.js <<'EOF'
const functions = require('firebase-functions');

exports.helloHttp = functions.https.onRequest((req, res) => {
  res.send('Hello from Ahmadify Cloud Functions!');
});
EOF

cat > functions/README.md <<'EOF'
# Firebase Functions

This folder contains Firebase Cloud Functions for Ahmadify.

Deploy with:

  firebase deploy --only functions

EOF

# GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/flutter.yml <<'EOF'
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - name: Install Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - name: Flutter pub get
        run: flutter pub get
      - name: Analyze
        run: flutter analyze
      - name: Run tests
        run: flutter test --no-pub
EOF

echo "Project skeleton created."

cat <<'EOF'

Next steps:
1) Copy .env.example to .env and fill values (FIREBASE_* and GOOGLE_MAPS_API_KEY).
2) Add Firebase platform files:
   - Android: android/app/google-services.json
   - iOS: ios/Runner/GoogleService-Info.plist
   Do NOT commit these to repository.
3) Open project in your editor (Android Studio / VS Code) and run:
   flutter pub get
   flutter run

4) To create a ZIP:
   cd ..
   zip -r Ahmadify.zip Ahmadify

If you want the expanded, fully modular code (auth flows, rent/services/materials modules, chat, admin UI, Firestore rules as earlier discussed), reply and I will generate a second script that injects the complete module source files (models, services, screens) into this project directory.

EOF

exit 0