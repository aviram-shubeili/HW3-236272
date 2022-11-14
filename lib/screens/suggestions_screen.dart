import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/providers/saved_notifier.dart';
import 'package:hello_me/screens/login_screen.dart';
import 'package:hello_me/screens/user_profile/profile_snapping__page.dart';
import 'package:hello_me/screens/saved_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_notifier.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated =
        context.watch<AuthNotifier>().status == Status.Authenticated;
    final loginActionButton = isAuthenticated
        ? const Icon(Icons.exit_to_app)
        : const Icon(Icons.login);
    return ProfileSnappingPage(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (context) {
                return SavedScreen();
              }));
            },
            tooltip: 'Saved suggestions',
          ),
          IconButton(
            icon: loginActionButton,
            onPressed: onClickedLoginPage,
            tooltip: 'Login',
          )
        ],
      ),
      body: _buildSuggestions(),
    ));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        final saved = context.watch<SavedNotifier>().saved;
        final alreadySaved = saved.contains(_suggestions[index].asPascalCase);
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                context
                    .read<SavedNotifier>()
                    .removeSaved(_suggestions[index].asPascalCase);
              } else {
                context
                    .read<SavedNotifier>()
                    .addSaved(_suggestions[index].asPascalCase);
              }
            });
          },
        );
      },
    );
  }

  void onClickedLoginPage() {
    if (context.read<AuthNotifier>().status == Status.Authenticated) {
      context.read<AuthNotifier>().signOut();
      _showLoggedOutSnackBar();
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return LoginScreen();
    }));
  }

  void _showLoggedOutSnackBar() {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        content: const Text(
          'Successfully logged out',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
