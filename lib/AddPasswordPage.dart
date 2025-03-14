import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/password_entry.dart';


class AddPasswordPage extends StatefulWidget {
  @override
  _AddPasswordPageState createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final entry = PasswordEntry(
        login: _loginController.text,
        password: _passwordController.text,
        website: _websiteController.text,
      );
      Navigator.pop(context, entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить пароль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Логин'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите логин';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Сайт'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите сайт';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePassword,
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}