import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
/**
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
**/
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:medifirst/doctor_app/features/home/presentation/doctor_home_screen.dart';
import 'package:medifirst/features/auth/controller/auth_controller.dart';
import 'package:medifirst/features/auth/presentation/screens/splash_page.dart';
import 'package:medifirst/features/auth/presentation/screens/welcome_screen.dart';
import 'package:medifirst/features/home/presentation/screens/home_screen.dart';
import 'package:medifirst/pharmacy_app/features/pharmacy_home/presentation/screens/pharmacy_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'core/constants/constants.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/consultation/controller/video_call_controller.dart';
import 'features/consultation/presentation/screens/incoming_call_screen.dart';
import 'features/consultation/presentation/screens/incoming_video_call_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

bool? login;

void main() async {
  runZonedGuarded(() async{
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool(Constants.isLogin);
    login = isLogin;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    const fatalError = true;
    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };
    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };
    runApp(const ProviderScope(child: MyApp()));
    FlutterNativeSplash.remove();
  }, (Object error, StackTrace? stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    debugPrintStack(stackTrace: stack, label: error.toString());
  });

  /**
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
      **/

}



class MyApp extends ConsumerStatefulWidget {

  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String? variant;

  Future<void> getVariant() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? flavor = prefs.getString(Constants.appTypeKey);
    variant = flavor;

  }
/**
  void setupNotificationHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleIncomingCall(message.data);
      initCallKit(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleIncomingCall(message.data);
      initCallKit(message.data);
    });
  }
**/
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    if (message.data['type'] == 'video_call') {
      // Show a full-screen intent notification on Android
      // or a VoIP notification on iOS
      await showIncomingCallNotification(message.data);
    }
  }

  Future<void> showIncomingCallNotification(Map<String, dynamic> data) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'video_call_channel_id',
      'Video Calls',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Incoming Video Call',
      'Video call from ${data['callerName']}',
      platformChannelSpecifics,
      payload: json.encode(data),
    );
  }

  void handleIncomingCall(Map<String, dynamic> data) {
    if (data['type'] == 'call') {
      // Show an incoming call screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IncomingCallScreen(
            callId: data['callId'],
            callerId: data['caller'],
          ),
        ),
      );
    } else if (data['type'] == 'video_call') {
      // Show an incoming video call screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IncomingVideoCallScreen(
            callId: data['callId'],
            callerId: data['caller'],
            callerName: data['callerName'],
          ),
        ),
      );
    }
  }
/**
  void initCallKit(Map<String, dynamic> data) {
    FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event?.event) {
        case Event.actionCallIncoming:
          // Show incoming call UI
          break;
        case Event.actionCallAccept:
          // User accepted the call, start the call
          ref.read(videoCallProvider.notifier).answerVideoCall(data['callId']);
          break;
        case Event.actionCallDecline:
          // User declined the call
          ref.read(videoCallProvider.notifier).answerVideoCall(data['callId']);
          ref.read(videoCallProvider.notifier).endVideoCall();
          break;
        default:
          break;
      }
    });
  }

  Future<void> showCallkitIncoming(String uuid, String callerName) async {
    final params = CallKitParams(
        id: uuid,
        nameCaller: callerName,
        appName: 'Your App Name',
        avatar: 'https://your-avatar-url.com/avatar.png',
        handle: '',
        type: 1,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
        headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        android: const AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            ringtonePath: 'system_ringtone_default',
            backgroundColor: '#0955fa',
            backgroundUrl: 'assets/test.png',
            actionColor: '#4CAF50'),
        ios: const IOSParams(
            iconName: 'CallKitLogo',
            handleType: '',
            supportsVideo: true,
            maximumCallGroups: 2,
            maximumCallsPerCallGroup: 1,
            audioSessionMode: 'default',
            audioSessionActive: true,
            audioSessionPreferredSampleRate: 44100.0,
            audioSessionPreferredIOBufferDuration: 0.005,
            supportsDTMF: true,
            supportsHolding: true,
            supportsGrouping: false,
            supportsUngrouping: false,
            ringtonePath: 'system_ringtone_default'));
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
**/

  /// **Prevent screenshot & screen recording on Android**
  /**
  Future<void> _secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
      **/

  /// **Detect screen recording on iOS**
  /**
  void _detectScreenRecording() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Platform.isIOS) {
        bool isCaptured = false;
        const EventChannel('screen_recording_channel').receiveBroadcastStream().listen((event) {
          isCaptured = event as bool;
          if (isCaptured) {
            print("Screen recording detected!");
            // You can take action like showing an alert or closing the app
          }
        });
      }
    });
  }
  **/
  @override
  void initState() {
    super.initState();
    /**
    if (Platform.isAndroid) {
      _secureScreen();
    } else if (Platform.isIOS) {
      _detectScreenRecording();
    }
        **/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVariant();
      //setupNotificationHandlers();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    });
  }



  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final doctor = ref.watch(doctorProvider);
    final pharmacy = ref.watch(pharmacyProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: HomeScreen(),
      home: login == true? const LoginScreen():const WelcomeScreen(),
    );
  }
}
