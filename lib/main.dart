import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // เรียกใช้งานฟังก์ชันเพื่อแสดงการแจ้งเตือนในโหมด foreground
    _firebaseMessagingForegroundMessageHandler(message);
  });
  runApp(const MyApp());
}
Future<void> _firebaseMessagingForegroundMessageHandler(RemoteMessage message) async {
  // ignore: unused_local_variable
  AndroidNotification? android = message.notification?.android;
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'high_importance_channel', // channel ID
    'High Importance Notifications', // channel name
    importance: Importance.max,
    priority: Priority.high,
    // ระบุ smallIcon ที่ต้องการแสดงในการแจ้งเตือน
    icon: 'flutter_logo',
  );
  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    notificationDetails,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ignore: unused_local_variable
  AndroidNotification? android = message.notification?.android;
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'high_importance_channel', // channel ID
    'High Importance Notifications', // channel name
    importance: Importance.max,
    priority: Priority.high,
    // ระบุ smallIcon ที่ต้องการแสดงในการแจ้งเตือน
    icon: 'flutter_logo',
  );
  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['title'],
    message.data['body'],
    notificationDetails,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//ส่วนการรับToken
class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    _getToken();
    // _configureFirebaseMessaging();
  }

  void _getToken() async {
    try {
      deviceToken = await _messaging.getToken();
      print(deviceToken);
    } catch (e) {
      print('Token retrieval failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Welcome to Firebase Messaging Demo'),
      ),
    );
  }
}