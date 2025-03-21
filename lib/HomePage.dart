import 'package:flutter/material.dart';
import 'AddPasswordPage.dart';
import 'SearchDelegate.dart';
import 'models/password_entry.dart';
import 'PasswordDetailPage.dart';
import 'GeneratePasswordPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_screen.dart';

final _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addPassword(PasswordEntry entry) async {
    await _firestore.collection('passwords').add({
      'login': entry.login,
      'password': entry.password,
      'website': entry.website,
    });
  }

  void _deletePassword(String documentId) async {
    await _firestore.collection('passwords').doc(documentId).delete();
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
              final snapshot = await _firestore.collection('passwords').get();
              final passwords = snapshot.docs.map((doc) => PasswordEntry(
                id: doc.id,
                login: doc['login'],
                password: doc['password'],
                website: doc['website'],
              )).toList();

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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('passwords').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          }

          final passwords = snapshot.data!.docs.map((doc) => PasswordEntry(
            id: doc.id,
            login: doc['login'],
            password: doc['password'],
            website: doc['website'],
          )).toList();

          return ListView.builder(
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
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deletePassword(entry.id);
                  },
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
            heroTag: 'generatePassword',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _navigateToAddPasswordPage,
            child: Icon(Icons.add),
            heroTag: 'addPassword',
          ),
        ],
      ),
    );
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
}