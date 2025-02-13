import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DataRepository.dart'; // Assuming DataRepository is where user data is saved.

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Display "Welcome Back" snackbar after page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeBackSnackBar();
    });
  }

  // Load user data from the repository
  void _loadUserData() async {
    await DataRepository.loadData();
    setState(() {
      _firstNameController.text = DataRepository.firstName;
      _lastNameController.text = DataRepository.lastName;
      _phoneController.text = DataRepository.phone;
      _emailController.text = DataRepository.email;
    });
  }

  // Method to launch a URL (Phone, SMS, Email)
  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // If the URL can't be launched, show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("This URL cannot be launched."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // Show the "Welcome Back" Snackbar
  void _showWelcomeBackSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome Back, ${widget.username}!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Save data when user makes changes to the profile
  void _saveProfile() {
    DataRepository.firstName = _firstNameController.text;
    DataRepository.lastName = _lastNameController.text;
    DataRepository.phone = _phoneController.text;
    DataRepository.email = _emailController.text;

    // Save data to the repository
    DataRepository.saveData();

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back ${widget.username}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name TextField
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 10),

            // Last Name TextField
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number TextField with buttons for Telephone and SMS
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    // Launch the phone dialer with the phone number
                    _launchURL(Uri.parse('tel:${_phoneController.text}'));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () {
                    // Launch the SMS app with the phone number
                    _launchURL(Uri.parse('sms:${_phoneController.text}'));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Email TextField with Mail button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () {
                    // Launch the email client with the email address
                    _launchURL(Uri.parse('mailto:${_emailController.text}'));
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Save Profile Button
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
