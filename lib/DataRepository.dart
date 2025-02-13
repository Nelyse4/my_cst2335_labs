import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String username = "";
  static String firstName = "";
  static String lastName = "";
  static String phone = "";
  static String email = "";

  // Load data from EncryptedSharedPreferences based on the username
  static Future<void> loadData() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

    // Use username as part of the key
    firstName = await prefs.getString("${username}_firstName") ?? "";
    lastName = await prefs.getString("${username}_lastName") ?? "";
    phone = await prefs.getString("${username}_phone") ?? "";
    email = await prefs.getString("${username}_email") ?? "";
  }

  // Save data to EncryptedSharedPreferences based on the username
  static Future<void> saveData() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

    // Save using username-specific keys
    await prefs.setString("${username}_firstName", firstName);
    await prefs.setString("${username}_lastName", lastName);
    await prefs.setString("${username}_phone", phone);
    await prefs.setString("${username}_email", email);
  }
}
