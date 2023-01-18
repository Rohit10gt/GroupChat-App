import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'package:chatboat/Buttons.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation coloranimation;

  @override
  void initState() {
    super.initState();
    controller=AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutSine);
    coloranimation = ColorTween(begin: Colors.black, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() { });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: coloranimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 80,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade900,
                  ), child: AnimatedTextKit(
                animatedTexts: [TypewriterAnimatedText('ChatBoat')],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  pause: Duration(milliseconds: 3000),
                ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
              child: Divider(
                color: Colors.grey.shade200,
                indent: 60,
                endIndent: 60,
                thickness: 1.75,
              ),
            ),
            RoundedButton(Colors.blueAccent, (){Navigator.pushNamed(context, 'login_screen');}, 'Log In'),
            RoundedButton(Colors.redAccent, (){Navigator.pushNamed(context, 'registration_screen');}, 'Register')
          ],
        ),
      ),
    );
  }
}
