import 'package:flutter/material.dart';

import 'Folder.dart';

class FolderSearch extends SearchDelegate<Folder?> {
  final List<Folder> folders;

  FolderSearch(this.folders);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.blueGrey,
      primaryColorBrightness: Brightness.dark,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Folder> suggestions = query.isEmpty
        ? []
        : folders.where((folder) => folder.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.folder, color: Colors.blueGrey),
          title: RichText(
            text: TextSpan(
              text: suggestions[index].name.substring(0, query.length),
              style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestions[index].name.substring(query.length),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          onTap: () {
            close(context, suggestions[index]);
          },
        );
      },
    );
  }
}
