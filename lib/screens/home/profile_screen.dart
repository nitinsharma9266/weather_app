import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Weather User';
  String email = 'user@example.com';

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  void _editProfile() {
    final nameController = TextEditingController(
      text: userName,
    );

    final emailController = TextEditingController(
      text: email,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  userName = nameController.text.trim();
                  email = emailController.text.trim();
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // TEMPERATURE UNIT
  // ============================================================

  void _selectTemperatureUnit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Temperature Unit'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Celsius (°C)'),
                value: 'C',
                groupValue: WeatherApp.temperatureUnit.value,
                onChanged: (value) {
                  if (value == null) return;

                  WeatherApp.temperatureUnit.value = value;

                  Navigator.pop(context);

                  setState(() {});
                },
              ),

              RadioListTile<String>(
                title: const Text('Fahrenheit (°F)'),
                value: 'F',
                groupValue: WeatherApp.temperatureUnit.value,
                onChanged: (value) {
                  if (value == null) return;

                  WeatherApp.temperatureUnit.value = value;

                  Navigator.pop(context);

                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DARK MODE
  // ============================================================

  void _toggleDarkMode(bool value) {
    WeatherApp.themeMode.value =
    value ? ThemeMode.dark : ThemeMode.light;

    setState(() {});
  }

  // ============================================================
  // ABOUT APP
  // ============================================================

  void _showAboutApp() {
    showAboutDialog(
      context: context,
      applicationName: 'Weather App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.cloud,
        size: 45,
      ),
      applicationLegalese: '© 2026 Weather App',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        WeatherApp.themeMode.value == ThemeMode.dark;

    final String temperatureUnit =
    WeatherApp.temperatureUnit.value == 'C'
        ? 'Celsius (°C)'
        : 'Fahrenheit (°F)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==================================================
            // PROFILE PHOTO
            // ==================================================

            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // USER NAME
            // ==================================================

            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // ==================================================
            // EMAIL
            // ==================================================

            Text(
              email,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // EDIT PROFILE
            // ==================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text(
                  'Edit Profile',
                ),
                subtitle: const Text(
                  'Change your name and email',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: _editProfile,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // TEMPERATURE UNIT
            // ==================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.thermostat,
                ),
                title: const Text(
                  'Temperature Unit',
                ),
                subtitle: Text(
                  temperatureUnit,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: _selectTemperatureUnit,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DARK MODE
            // ==================================================

            Card(
              child: SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode,
                ),
                title: const Text(
                  'Dark Mode',
                ),
                subtitle: const Text(
                  'Change app appearance',
                ),
                value: isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // SETTINGS
            // ==================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.settings,
                ),
                title: const Text(
                  'Settings',
                ),
                subtitle: const Text(
                  'Manage app settings',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.settings,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // ABOUT
            // ==================================================

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.info_outline,
                ),
                title: const Text(
                  'About App',
                ),
                subtitle: const Text(
                  'App information',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: _showAboutApp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}