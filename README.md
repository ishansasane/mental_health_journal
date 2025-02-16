# Mental Health Journal

## 📌 Overview
Mental Health Journal is a **Flutter** application designed to help users track their mental health and mood through journaling. It integrates **sentiment analysis**, visualization tools, and user-friendly UI/UX to provide meaningful insights into mental well-being.

## 🚀 Features
- 📖 **Journaling**: Write daily entries and track emotions.
- 😊 **Sentiment Analysis**: Automatically analyze journal entries.
- 📊 **Mood Tracking & Visualization**: View emotional trends using heatmaps and charts.
- 🔒 **Secure & Private**: Data stored securely using **Supabase**.
- 🌗 **Dark Mode Support**.
- 🎨 **Theming with FlexColorScheme**.
- 🔔 **Notifications & Reminders** (Planned for future releases).

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **State Management**: Provider
- **Backend**: Supabase
- **UI Enhancements**: Google Fonts, FlexColorScheme
- **Charts & Data Visualization**: fl_chart, flutter_heatmap_calendar

## 📱 Screenshots
_(Add app screenshots here)_

## ⚙️ Setup & Installation

### **1️⃣ Clone the Repository**
```sh
 git clone https://github.com/yourusername/mental_health_journal.git
 cd mental_health_journal
```

### **2️⃣ Install Dependencies**
```sh
 flutter pub get
```

### **3️⃣ Setup Supabase (Backend)**
- Create an account on [Supabase](https://supabase.io/).
- Set up authentication and database tables.
- Add your Supabase API keys to `lib/config.dart`:
```dart
 const String supabaseUrl = "YOUR_SUPABASE_URL";
 const String supabaseKey = "YOUR_SUPABASE_ANON_KEY";
```

### **4️⃣ Run the App**
```sh
 flutter run
```

## 🎨 Customization
### **App Icon & Splash Screen**
#### **Change App Icon**
```sh
flutter pub run flutter_launcher_icons:main
```
Edit `pubspec.yaml`:
```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
```

#### **Change Splash Screen**
```sh
flutter pub run flutter_native_splash:create
```
Edit `pubspec.yaml`:
```yaml
flutter_native_splash:
  color: "#000000"
  image: assets/splash.png
```

## 📦 Build & Release
To generate an APK:
```sh
 flutter build apk --release
```
To generate an AAB (for Play Store):
```sh
 flutter build appbundle
```

## 📜 License
This project is licensed under the **MIT License**.

## 🤝 Contributing
Feel free to **fork** the repository, raise issues, or submit pull requests!

## 📞 Contact
For queries or collaborations, reach out at **your.email@example.com**.

