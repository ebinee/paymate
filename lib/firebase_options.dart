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
    apiKey: 'AIzaSyAy1LydpipCUaBOteO8dIalZ8Vh1lQC3jo',
    appId: '1:120829378292:web:faa8686218fac392ee68a1',
    messagingSenderId: '120829378292',
    projectId: 'paymate-3e62b',
    authDomain: 'paymate-3e62b.firebaseapp.com',
    databaseURL: 'https://paymate-3e62b-default-rtdb.firebaseio.com',
    storageBucket: 'paymate-3e62b.appspot.com',
    measurementId: 'G-ZYVT5S6Z0P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYVCHudzyYnbPwl_Ou4rgjNfyPjGm4Aqs',
    appId: '1:120829378292:android:25a4b9f7ad84796bee68a1',
    messagingSenderId: '120829378292',
    projectId: 'paymate-3e62b',
    databaseURL: 'https://paymate-3e62b-default-rtdb.firebaseio.com',
    storageBucket: 'paymate-3e62b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2W-_PMYr0CF8c7NwPkUaCNDTMno4_YfI',
    appId: '1:120829378292:ios:1ccb5d4959940c58ee68a1',
    messagingSenderId: '120829378292',
    projectId: 'paymate-3e62b',
    databaseURL: 'https://paymate-3e62b-default-rtdb.firebaseio.com',
    storageBucket: 'paymate-3e62b.appspot.com',
    iosBundleId: 'com.example.paymate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2W-_PMYr0CF8c7NwPkUaCNDTMno4_YfI',
    appId: '1:120829378292:ios:1ccb5d4959940c58ee68a1',
    messagingSenderId: '120829378292',
    projectId: 'paymate-3e62b',
    databaseURL: 'https://paymate-3e62b-default-rtdb.firebaseio.com',
    storageBucket: 'paymate-3e62b.appspot.com',
    iosBundleId: 'com.example.paymate',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAy1LydpipCUaBOteO8dIalZ8Vh1lQC3jo',
    appId: '1:120829378292:web:1d3a4209809fd548ee68a1',
    messagingSenderId: '120829378292',
    projectId: 'paymate-3e62b',
    authDomain: 'paymate-3e62b.firebaseapp.com',
    databaseURL: 'https://paymate-3e62b-default-rtdb.firebaseio.com',
    storageBucket: 'paymate-3e62b.appspot.com',
    measurementId: 'G-3888GNNWFQ',
  );

}