import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatboat/screens/welcome_screen.dart';
import 'package:chatboat/screens/login_screen.dart';
import 'package:chatboat/screens/registration_screen.dart';
import 'package:chatboat/screens/chat_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Chatboat());}

class Chatboat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen':(context)=>WelcomeScreen(),
        'login_screen' : (context) =>LoginScreen(),
        'registration_screen' : (context) =>RegistrationScreen(),
        'chat_screen': (context) =>ChatScreen()
      },
    );
  }
}
