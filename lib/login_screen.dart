import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Adjust this import according to your app structure

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
  final Random _random = Random();
  List<Map<String, String>> profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final storedProfiles = prefs.getStringList('profiles') ?? [];
    setState(() {
      profiles = storedProfiles.map((profile) {
        final parts = profile.split(':');
        return {'name': parts[0], 'email': parts[1]};
      }).toList();
    });
  }

  Future<void> _addOrUpdateProfile(String email, String password, String name, {bool isNew = true}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isNew) {
      profiles.add({'name': name, 'email': email});
      prefs.setStringList('profiles', profiles.map((profile) => '${profile['name']}:${profile['email']}').toList());
    }
    prefs.setString('$email-pass', password);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyHomePage()));
  }

  void _showAuthDialog(bool isNew, {String profileEmail = ''}) {
    String title = isNew ? 'Sign Up' : 'Login';
    _emailController.text = profileEmail;
    if (!isNew) {
      final profile = profiles.firstWhere((profile) => profile['email'] == profileEmail);
      _nameController.text = profile['name']!;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNew)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(isNew ? 'Sign Up' : 'Login'),
            onPressed: () {
              _addOrUpdateProfile(_emailController.text, _passwordController.text, _nameController.text, isNew: isNew);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Who's Watching?",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: profiles.map((profile) {
                Color color = _colors[_random.nextInt(_colors.length)];
                return GestureDetector(
                  onTap: () => _showAuthDialog(false, profileEmail: profile['email']!),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: color,
                    child: Center(
                      child: Text(
                        profile['name']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList()
                ..add(
                  GestureDetector(
                    onTap: () => _showAuthDialog(true),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: const Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
