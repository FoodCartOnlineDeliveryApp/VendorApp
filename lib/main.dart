import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mealup_restaurant_side/routes/custome_router.dart';
import 'package:mealup_restaurant_side/routes/route_names.dart';
import 'package:mealup_restaurant_side/utilities/prefConstatnt.dart';
import 'package:mealup_restaurant_side/utilities/preference.dart';
import 'package:sizer/sizer.dart';
import 'localization/lang_localizations.dart';
import 'localization/localization_constant.dart';

//Firebase Notification initialization
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print('Message map: ${message.toMap()}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  HttpOverrides.global = MyHttpOverrides();
  //Firebase Notification initialization
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyCHI5EEBZQWNQ_mVxuxO4RAtQacZ1drBcE',
        appId: '1:849512019728:android:5e76863b87415026961795',
        messagingSenderId: '849512019728',
        projectId: 'foodcartdeliveryapp'),
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // final fcmToken = await messaging.getToken();
  // print('fcmToken:= $fcmToken');
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('Message map: ${message.toMap()}');
    print("onMessageOpenedApp: ${message.data}");

    // if (message.data["navigation"] == "/your_route") {
    //   int _yourId = int.tryParse(message.data["id"]) ?? 0;
    //   Navigator.push(navigatorKey.currentState!.context,
    //       MaterialPageRoute(builder: (context) => Staff(isActionBar: true)));
    // }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  ///Managing local notification///
  final notificationSound = 'sound.mp3';
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      // playSound: true,
      sound: RawResourceAndroidNotificationSound(
          notificationSound.split('.').first));
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    //      onSelectNotification: (payload) async {
    //   print("onMessageOpenedAppLocal: $payload");

    // }
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  ///End of managing local notification///

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message map: ${message.toMap()}');
    print('Message data: ${message.data}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      print('Message also contained a notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound(
                  notificationSound.split('.').first)
              // other properties...
              ),
        ),
        // payload: message.notification.title
        //         .contains("Do you want to confirm your booking")
        //     ? "confirm" + message.data['booking']
        //     : message.data['booking']
      );
    }
  });

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new MyApp());
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
          setState(() {
            this._locale = local;
          })
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: ThemeData(primaryColor: const Color(0xFF4A00E0)),
            locale: _locale,
            supportedLocales: [
              Locale(ENGLISH, 'US'),
              Locale(SPANISH, 'ES'),
              Locale(ARABIC, 'AE'),
            ],
            localizationsDelegates: [
              LanguageLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocal, supportedLocales) {
              for (var local in supportedLocales) {
                if (local.languageCode == deviceLocal!.languageCode &&
                    local.countryCode == deviceLocal.countryCode) {
                  return deviceLocal;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            initialRoute:
                SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) ==
                        true
                    ? homeRoute
                    : loginRoute,
            onGenerateRoute: CustomRouter.allRoutes,
          );
        },
      );
    }
  }
}
