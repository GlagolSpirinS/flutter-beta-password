import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneratePasswordPage extends StatefulWidget {
  @override
  _GeneratePasswordPageState createState() => _GeneratePasswordPageState();
}

class _GeneratePasswordPageState extends State<GeneratePasswordPage> {
  String generatedLogin = '';
  String generatedPassword = '';
  bool includeNumbers = true;
  bool includeSymbols = true;
  bool includeUppercase = true;
  bool includeLowercase = true;
  double passwordLength = 12;

  final String _lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  final String _uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _numbers = '0123456789';
  final String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  final Random _random = Random();

  void _generateLogin() {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    generatedLogin = 'user_' +
        List.generate(8, (index) => chars[_random.nextInt(chars.length)]).join();
    setState(() {});
  }

  void _generatePassword() {
    String characters = '';
    if (includeLowercase) characters += _lowercaseLetters;
    if (includeUppercase) characters += _uppercaseLetters;
    if (includeNumbers) characters += _numbers;
    if (includeSymbols) characters += _symbols;

    if (characters.isEmpty) {
      setState(() {
        generatedPassword = 'Выберите хотя бы один параметр';
      });
      return;
    }

    generatedPassword = List.generate(passwordLength.toInt(),
            (index) => characters[_random.nextInt(characters.length)]).join();
    setState(() {});
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопировано в буфер обмена: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Генерация пароля')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextRow('Логин:', generatedLogin, () => _copyToClipboard(context, generatedLogin)),
            ElevatedButton(onPressed: _generateLogin, child: Text('Сгенерировать логин')),
            SizedBox(height: 20),
            _buildTextRow('Пароль:', generatedPassword, () => _copyToClipboard(context, generatedPassword)),
            ElevatedButton(onPressed: _generatePassword, child: Text('Сгенерировать пароль')),
            SizedBox(height: 20),
            _buildPasswordSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String label, String value, VoidCallback onCopy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        Row(
          children: [
            Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
            IconButton(icon: Icon(Icons.copy), onPressed: onCopy),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Настройки пароля:', style: TextStyle(fontSize: 18)),
        _buildCheckbox('Цифры (0-9)', includeNumbers, (value) => setState(() => includeNumbers = value!)),
        _buildCheckbox('Символы (!@#\$%^&*)', includeSymbols, (value) => setState(() => includeSymbols = value!)),
        _buildCheckbox('Верхний регистр (A-Z)', includeUppercase, (value) => setState(() => includeUppercase = value!)),
        _buildCheckbox('Нижний регистр (a-z)', includeLowercase, (value) => setState(() => includeLowercase = value!)),
        SizedBox(height: 10),
        Text('Длина пароля: ${passwordLength.toInt()}'),
        Slider(
          value: passwordLength,
          min: 6,
          max: 32,
          divisions: 26,
          label: passwordLength.toInt().toString(),
          onChanged: (value) => setState(() => passwordLength = value),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(title: Text(title), value: value, onChanged: onChanged);
  }
}
