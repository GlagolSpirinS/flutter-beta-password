import 'package:flutter/material.dart';
import 'AddPasswordPage.dart';
import 'SearchDelegate.dart';
import 'models/password_entry.dart';
import 'PasswordDetailPage.dart';
import 'GeneratePasswordPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PasswordEntry> passwords = [];

  void _addPassword(PasswordEntry entry) {
    setState(() {
      passwords.add(entry);
    });
  }

  void _navigateToAddPasswordPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPasswordPage(),
      ),
    );

    if (result != null) {
      _addPassword(result);
    }
  }

  void _navigateToGeneratePasswordPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratePasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои пароли'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: PasswordSearchDelegate(passwords),
              );

              if (result != null) {
                // Обработка выбранного элемента
                print('Выбран элемент: ${result.website}');
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: passwords.length,
        itemBuilder: (context, index) {
          final entry = passwords[index];
          return ListTile(
            title: Text(entry.website),
            subtitle: Text(entry.login),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasswordDetailPage(entry: entry),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _navigateToGeneratePasswordPage,
            child: Icon(Icons.lock),
            heroTag: 'generatePassword', // Уникальный тег для FAB
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _navigateToAddPasswordPage,
            child: Icon(Icons.add),
            heroTag: 'addPassword', // Уникальный тег для FAB
          ),
        ],
      ),
    );
  }
}