import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const loadingIndicator = CircularProgressIndicator();

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
    );
    var greeterText =
        const Text('Welcome to Startup Names Generator, please log in!');
    var emailField = TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            border: outlineInputBorder,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Email'));
    var passwordField = TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            border: outlineInputBorder,
            contentPadding: EdgeInsets.all(16.0),
            hintText: 'Password'));
    var loginButton = MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      minWidth: double.infinity,
      color: Colors.deepPurple,
      onPressed: onClickedSignIn,
      child: const Text(
        'Log in',
        style: TextStyle(color: Colors.white),
      ),
    );
    var signupButton = MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      minWidth: double.infinity,
      color: Colors.blue,
      onPressed: onClickedSignUp,
      child: const Text(
        'New user? Click to sign up',
        style: TextStyle(color: Colors.white),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                greeterText,
                const SizedBox(height: 10),
                emailField,
                const SizedBox(height: 10),
                passwordField,
                const SizedBox(height: 16),
                isAuthenticating() ? loadingIndicator : loginButton,
                const SizedBox(height: 10),
                isAuthenticating() ? loadingIndicator : signupButton,
              ],
            )));
  }

  bool isAuthenticating() {
    return context.watch<AuthNotifier>().status == Status.Authenticating;
  }

  Future<void> onClickedSignIn() async {
    var isSuccess = await context
        .read<AuthNotifier>()
        .signIn(emailController.text, passwordController.text);
    if (isSuccess) {
      Navigator.pop(context);
    } else {
      _showUnsuccessfulSnackBar();
    }
  }

  Future<void> onClickedSignUp() async {
    final _formKey = GlobalKey<FormState>();
    showModalBottomSheet<bool>(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        builder: (ctx) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Please confirm your password below:'),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                    child: TextFormField(
                      validator: (confirmedPass) {
                        return passwordController.text != confirmedPass ? 'Passwords must match' : null;
                      },
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                            hintText: 'Password'))),
                    const SizedBox(height: 10),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      minWidth: double.infinity,
                      color: Colors.blue,
                      onPressed: () {
                        if(_formKey!.currentState!.validate()) {
                          Navigator.pop(context);
                          _signUpUser();
                        }
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ]));
        });
  }

  Future<void> _signUpUser() async {
    var userCredentials = await context
        .read<AuthNotifier>()
        .signUp(emailController.text, passwordController.text);
    if (userCredentials != null) {
      Navigator.pop(context);
    } else {
      _showUnsuccessfulSnackBar();
    }
  }

  void _showUnsuccessfulSnackBar() {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        content: const Text(
          'There was an error logging into the app',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
