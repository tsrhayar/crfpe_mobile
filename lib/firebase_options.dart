// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAv78Z4VXeDqPmyu8IEe7r9lLg-6FJ2ID8',
    appId: '1:89533257908:web:7a96a591a33edbec165fe1',
    messagingSenderId: '89533257908',
    projectId: 'crfpe-mobile',
    authDomain: 'crfpe-mobile.firebaseapp.com',
    storageBucket: 'crfpe-mobile.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBX_lYjHQDblB5RADWYW32VsZwZeXj5-Y8',
    appId: '1:89533257908:android:1d6c5d4ed9b1ac42165fe1',
    messagingSenderId: '89533257908',
    projectId: 'crfpe-mobile',
    storageBucket: 'crfpe-mobile.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAD2PaQC91VNfby_nTFbAuv7x2IOYoHRfA',
    appId: '1:89533257908:ios:bf2219a950f0ae80165fe1',
    messagingSenderId: '89533257908',
    projectId: 'crfpe-mobile',
    storageBucket: 'crfpe-mobile.appspot.com',
    iosBundleId: 'com.example.crfpeMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAD2PaQC91VNfby_nTFbAuv7x2IOYoHRfA',
    appId: '1:89533257908:ios:bf2219a950f0ae80165fe1',
    messagingSenderId: '89533257908',
    projectId: 'crfpe-mobile',
    storageBucket: 'crfpe-mobile.appspot.com',
    iosBundleId: 'com.example.crfpeMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAv78Z4VXeDqPmyu8IEe7r9lLg-6FJ2ID8',
    appId: '1:89533257908:web:0a83796cd02b4d1d165fe1',
    messagingSenderId: '89533257908',
    projectId: 'crfpe-mobile',
    authDomain: 'crfpe-mobile.firebaseapp.com',
    storageBucket: 'crfpe-mobile.appspot.com',
  );
}
