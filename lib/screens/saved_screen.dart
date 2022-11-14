import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/providers/saved_notifier.dart';
import 'package:hello_me/screens/user_profile/profile_snapping__page.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    var saved = context.watch<SavedNotifier>().saved;
    final tiles = saved.map((pair) {
      return Dismissible(
          key: ValueKey<String>(pair),
          background: Container(
              alignment: Alignment.centerLeft,
              color: Colors.redAccent,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3),
                      Text(
                        'Delete\nSuggestion',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                    ]),
              )),
          secondaryBackground: Container(
              alignment: Alignment.centerRight,
              color: Colors.redAccent,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Delete\nSuggestion',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                    ]),
              )),
          confirmDismiss: (_) async {
            if(await showConfirmDialogAndGetResponse(pair) == 'Yes') {
              context.read<SavedNotifier>().removeSaved(pair);
            };
          },
          child: ListTile(
            title: Text(
              pair,
              style: const TextStyle(fontSize: 18),
            ),
          ));
    }).toList();
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];
    return ProfileSnappingPage(child:  Scaffold(
        appBar: AppBar(
          title: const Text('Saved Suggestions'),
        ),
        body: ListView(
          children: divided,
        )));
  }

  void _showNotImplementedSnackBar(String featureName) {
    final snackBar = SnackBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.construction_rounded, color: Colors.white, size: 30),
          const SizedBox(width: 10),
          Text(
            '$featureName is not implemented yet',
            style: const TextStyle(fontSize: 18),
          ),
        ]));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String?> showConfirmDialogAndGetResponse(String savedName) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Suggestion'),
        content: Text('Are you sure you want to delete $savedName from your saved suggestions?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Yes'),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
