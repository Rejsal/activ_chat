import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/camera_provider.dart';
import 'package:activ_chat/providers/chat_provider.dart';
import 'package:activ_chat/providers/game_provider.dart';
import 'package:activ_chat/providers/group_provider.dart';
import 'package:activ_chat/providers/notification_provider.dart';
import 'package:activ_chat/screens/notification_screen.dart';
import 'package:activ_chat/screens/register_screen.dart';
import 'package:activ_chat/screens/splash_screen.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GroupProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CameraProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: kPrimary, fontFamily: 'Muli'),
        home: const SplashScreen(),
        routes: {
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          NotificationScreen.routeName: (context) => const NotificationScreen(),
        },
      ),
    );
  }
}
