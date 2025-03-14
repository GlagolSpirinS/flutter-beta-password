import 'package:flutter/material.dart';
import '../models/password_entry.dart';

class PasswordSearchDelegate extends SearchDelegate<PasswordEntry?> {
  final List<PasswordEntry> passwords;

  PasswordSearchDelegate(this.passwords);

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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = passwords.where((entry) =>
    entry.website.toLowerCase().contains(query.toLowerCase()) ||
        entry.login.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entry = results.elementAt(index);
        return ListTile(
          title: Text(entry.website),
          subtitle: Text(entry.login),
          onTap: () {
            close(context, entry); // Возвращаем выбранный элемент
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? passwords
        : passwords.where((entry) =>
    entry.website.toLowerCase().contains(query.toLowerCase()) ||
        entry.login.toLowerCase().contains(query.toLowerCase()));

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final entry = suggestions.elementAt(index);
        return ListTile(
          title: Text(entry.website),
          subtitle: Text(entry.login),
          onTap: () {
            query = entry.website; // Автозаполнение поиска
            showResults(context); // Показ результатов
          },
        );
      },
    );
  }
}