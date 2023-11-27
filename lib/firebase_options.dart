// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBhDAFY_iNO21eB7ujbHIGEngpGVoWVZ4A',
    appId: '1:204694127643:web:0eb07f133d4a09e37ae4be',
    messagingSenderId: '204694127643',
    projectId: 'todoappflutter-b8e33',
    authDomain: 'todoappflutter-b8e33.firebaseapp.com',
    storageBucket: 'todoappflutter-b8e33.appspot.com',
    measurementId: 'G-0K5TLFHJNS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBxKi4HSApkIbtNJLMKuUhuokEAIyYq3s',
    appId: '1:204694127643:android:2786e78851b11d8a7ae4be',
    messagingSenderId: '204694127643',
    projectId: 'todoappflutter-b8e33',
    storageBucket: 'todoappflutter-b8e33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_jKbc0lIKji0CJhyqYogXqMt448YcJIY',
    appId: '1:204694127643:ios:b078ae982412701d7ae4be',
    messagingSenderId: '204694127643',
    projectId: 'todoappflutter-b8e33',
    storageBucket: 'todoappflutter-b8e33.appspot.com',
    iosBundleId: 'com.example.todoapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_jKbc0lIKji0CJhyqYogXqMt448YcJIY',
    appId: '1:204694127643:ios:6ad627cf13db5cf97ae4be',
    messagingSenderId: '204694127643',
    projectId: 'todoappflutter-b8e33',
    storageBucket: 'todoappflutter-b8e33.appspot.com',
    iosBundleId: 'com.example.todoapp.RunnerTests',
  );
}
