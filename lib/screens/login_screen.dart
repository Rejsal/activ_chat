import 'package:activ_chat/components/common_button.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/screens/register_screen.dart';
import 'package:activ_chat/utils/constants.dart';
import 'package:activ_chat/utils/dialogs.dart';
import 'package:activ_chat/utils/helper.dart';
import 'package:activ_chat/utils/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: kPrimary,
      key: _key,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AnimatedTextKit(
                pause: const Duration(milliseconds: 2000),
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(kAppTitle, textStyle: kAppTitleStyle),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                validator: (value) => (value!.isEmpty)
                    ? 'Email is required'
                    : !Helper.isValidEmail(value)
                        ? 'Invalid Email'
                        : null,
                style: const TextStyle(color: Colors.white),
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Email Address'),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                onChanged: (value) {
                  password = value;
                },
                validator: (value) =>
                    (value!.isEmpty) ? 'Password is required' : null,
                style: const TextStyle(color: Colors.white),
                obscureText: _passwordVisible,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              user.status == Status.authenticating
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : CommonButton(
                      title: 'Login',
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (!await user.signIn(email, password)) {
                            await Dialogs.infoDialogWithoutTitle(
                                context, 'Invalid Login', 'Ok');
                          }
                        }
                      },
                    ),
              const SizedBox(
                height: 16.0,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'You don\'t have an account? ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Muli',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Signup',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, RegisterScreen.routeName),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Muli',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
