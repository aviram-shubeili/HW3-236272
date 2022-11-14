import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello_me/providers/auth_notifier.dart';
import 'package:hello_me/providers/profile_image_notifier.dart';
import 'package:hello_me/providers/saved_notifier.dart';
import 'package:hello_me/screens/suggestions_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ChangeNotifierProxyProvider<AuthNotifier, SavedNotifier>(
              create: (_) => SavedNotifier(),
              update: (_, authNotifier, savedNotifier) =>
                  savedNotifier!..update(authNotifier)),
          ChangeNotifierProxyProvider<AuthNotifier, ProfileImageNotifier>(
              create: (_) => ProfileImageNotifier(),
              update: (_, authNotifier, profileImageNotifier) =>
              profileImageNotifier!..update(authNotifier))
        ],
        child: MaterialApp(
          title: 'Startup Name Generator',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: SuggestionsScreen(),
        ));
  }
}
