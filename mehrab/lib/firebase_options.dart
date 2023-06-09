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
    apiKey: 'AIzaSyDe5sUVNjf6ecPReYAhsGv9nj5cK5zGLN8',
    appId: '1:807418382047:web:eb52718ac7a60d16edcb6a',
    messagingSenderId: '807418382047',
    projectId: 'mehrab-6fc17',
    authDomain: 'mehrab-6fc17.firebaseapp.com',
    databaseURL: 'https://mehrab-6fc17-default-rtdb.firebaseio.com',
    storageBucket: 'mehrab-6fc17.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzOAzhzjQs-a7LcHU3uydhu5HzPUJHa9E',
    appId: '1:807418382047:android:930d7b9cc54b9b84edcb6a',
    messagingSenderId: '807418382047',
    projectId: 'mehrab-6fc17',
    databaseURL: 'https://mehrab-6fc17-default-rtdb.firebaseio.com',
    storageBucket: 'mehrab-6fc17.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABwPlGFaBmlb93jns-kd6gh0Gy9xxwXHo',
    appId: '1:807418382047:ios:6d110d05215917a5edcb6a',
    messagingSenderId: '807418382047',
    projectId: 'mehrab-6fc17',
    databaseURL: 'https://mehrab-6fc17-default-rtdb.firebaseio.com',
    storageBucket: 'mehrab-6fc17.appspot.com',
    iosClientId: '807418382047-ootlhj9u5suleefnik9abs133k4hbafi.apps.googleusercontent.com',
    iosBundleId: 'com.example.mehrab',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABwPlGFaBmlb93jns-kd6gh0Gy9xxwXHo',
    appId: '1:807418382047:ios:6d110d05215917a5edcb6a',
    messagingSenderId: '807418382047',
    projectId: 'mehrab-6fc17',
    databaseURL: 'https://mehrab-6fc17-default-rtdb.firebaseio.com',
    storageBucket: 'mehrab-6fc17.appspot.com',
    iosClientId: '807418382047-ootlhj9u5suleefnik9abs133k4hbafi.apps.googleusercontent.com',
    iosBundleId: 'com.example.mehrab',
  );
}
