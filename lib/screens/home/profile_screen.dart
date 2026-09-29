import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================
  // USER PROFILE DATA
  // ============================================================

  String userName = 'Weather User';
  String phoneNumber = '';
  String email = 'user@example.com';

  // ============================================================
  // LOAD SAVED PROFILE
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('user_name');
    final savedPhone = prefs.getString('user_phone');
    final savedEmail = prefs.getString('user_email');

    if (!mounted) return;

    setState(() {
      if (savedName != null && savedName.isNotEmpty) {
        userName = savedName;
      }

      if (savedPhone != null) {
        phoneNumber = savedPhone;
      }

      if (savedEmail != null && savedEmail.isNotEmpty) {
        email = savedEmail;
      }
    });
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile({
    required String name,
    required String phone,
    required String userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_email', userEmail);

    if (!mounted) return;

    setState(() {
      userName = name;
      phoneNumber = phone;
      email = userEmail;
    });
  }

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  void _editProfile() {
    final nameController = TextEditingController(
      text: userName,
    );

    final phoneController = TextEditingController(
      text: phoneNumber,
    );

    final emailController = TextEditingController(
      text: email,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Profile',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // NAME
                TextField(
                  controller: nameController,
                  textCapitalization:
                  TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // PHONE
                TextField(
                  controller: phoneController,
                  keyboardType:
                  TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextField(
                  controller: emailController,
                  keyboardType:
                  TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            // SAVE
            ElevatedButton(
              onPressed: () async {
                final name =
                nameController.text.trim();

                final phone =
                phoneController.text.trim();

                final userEmail =
                emailController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter your name',
                      ),
                    ),
                  );
                  return;
                }

                if (userEmail.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter your email',
                      ),
                    ),
                  );
                  return;
                }

                await _saveProfile(
                  name: name,
                  phone: phone,
                  userEmail: userEmail,
                );

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profile updated successfully',
                    ),
                  ),
                );
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE PHOTO
            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 15),

            // NAME
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // PHONE
            if (phoneNumber.isNotEmpty)
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 17,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 5),

            // EMAIL
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 17,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    email,
                    textAlign: TextAlign.center,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // EDIT PROFILE
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                ),
                title: const Text(
                  'Edit Profile',
                ),
                subtitle: const Text(
                  'Change your name, phone and email',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: _editProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}