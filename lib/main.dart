import 'package:crfpe_mobile/firebase_options.dart';
import 'package:crfpe_mobile/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRFPE',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


// import 'package:crfpe_mobile/firebase_options.dart';
// import 'package:crfpe_mobile/pages/login/login.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:crfpe_mobile/services/notification_service.dart'; // Import the notification service

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
  
//   // Initialize NotificationService
//   final notificationService = NotificationService();
  
//   // Optionally, you can initialize notifications with a specific user ID here, if needed.
//   // For now, we'll initialize it without the user ID. Make sure to call initPusher() later as required.
//   notificationService.initPusher('user_id'); // Replace 'user_id' with the actual user ID

//   // Run the app
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CRFPE',
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }
