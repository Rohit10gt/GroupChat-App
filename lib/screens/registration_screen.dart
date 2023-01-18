import 'package:flutter/material.dart';
import 'package:chatboat/Buttons.dart';
import 'package:chatboat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String firstname;
  late String lastname;
  late String email;
  late String password;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      firstname=value;
                    },
                    decoration: kTextFlieldDecoration.copyWith(
                        hintText: 'First Name'
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      lastname=value;
                    },
                    decoration: kTextFlieldDecoration.copyWith(
                        hintText: 'Last Name'
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFlieldDecoration.copyWith(
                  hintText: 'Enter Your Email'
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFlieldDecoration.copyWith(
                  hintText: 'Enter a Password'
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(Colors.redAccent,
                    ()async{
              try {
                final newuser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                if(newuser != null){
                  Navigator.pushNamed(context, 'chat_screen');
                }
              }
              catch(e){
                print(e);
              }
              },
                'Register'),
          ],
        ),
      ),
    );
  }
}
