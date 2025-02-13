import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'ProfilePage.dart'; // Import the ProfilePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String imageSource = "images/question-mark.png"; // Default image

  @override
  void initState() {
    super.initState();
    // Delay loading credentials to ensure the Scaffold is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCredentials();
    });
  }

  // Function to load saved username and password
  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    if (username != null && password != null) {
      _usernameController.text = username;
      _passwordController.text = password;

      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Previous login name and passwords loaded.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await Future.delayed(Duration(seconds: 1));
              _usernameController.clear();
              _passwordController.clear();
            },
          ),
        ),
      );
    }
  }

  void _login() async {
    final password = _passwordController.text;
    setState(() {
      if (password == "QWERTY123") {
        imageSource = "images/light-bulb.png"; // Correct password: Change to light bulb
      } else {
        imageSource = "images/stop.png"; // Incorrect password: Change to stop sign
      }
    });

    if (password == "QWERTY123") {
      // Save credentials to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);

      // Navigate to ProfilePage after successful login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(username: _usernameController.text),
        ),
      );
    } else {
      _showSaveCredentialsDialog();
    }
  }


  // Function to show AlertDialog for saving credentials
  void _showSaveCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials?'),
          content: const Text('Would you like to save your username and password?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Clear saved credentials if the user selects "Cancel"
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');
                await prefs.remove('password');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Save credentials if the user selects "OK"
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', _usernameController.text);
                await prefs.setString('password', _passwordController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Username field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Login',
              ),
            ),
            const SizedBox(height: 10),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: _login,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.blue, fontSize: 30),
              ),
            ),

            const SizedBox(height: 20),

            // Image that changes based on the password entered
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
      // Floating Action Button to clear fields
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Clear Fields',
        child: const Icon(Icons.clear), // Icon for the FAB
      ),
    );
  }
}
