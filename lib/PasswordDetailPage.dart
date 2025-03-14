import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/password_entry.dart';

class PasswordDetailPage extends StatelessWidget {
  final PasswordEntry entry;

  PasswordDetailPage({required this.entry});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопировано в буфер обмена: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали пароля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сайт: ${entry.website}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Логин: ${entry.login}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Пароль: ${entry.password}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _copyToClipboard(context, entry.login),
                  child: Text('Копировать логин'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _copyToClipboard(context, entry.password),
                  child: Text('Копировать пароль'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}