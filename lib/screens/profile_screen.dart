import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wni/components/change_profile_dialog.dart';
import 'package:wni/components/detail_box.dart';
import 'package:wni/models/profile.dart';
import 'package:wni/provider/theme_provider.dart';
import 'package:wni/screens/signin_screen.dart';
import 'package:wni/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Masukkan $field baru',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await ProfileService.usersCollection
          .doc(ProfileService.currentUser!.uid)
          .update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: ProfileService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (!snapshot.hasData) {
                return const Text('User not found');
              }
              Profile profile = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24.0),
                        //
                        // Profile Picture
                        Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 48, 85, 77),
                                  width: 2,
                                ),
                              ),
                              child: profile.profileUrl != null &&
                                      Uri.parse(profile.profileUrl!).isAbsolute
                                  ? CircleAvatar(
                                      radius: 75,
                                      backgroundImage:
                                          NetworkImage(profile.profileUrl!),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const CircleAvatar(
                                      radius: 75,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            Positioned(
                              right: 1.0,
                              bottom: 1.0,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ChangeProfileDialog(
                                            profile: profile);
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color.fromARGB(255, 245, 250, 225),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        //
                        //
                        DetailBox(
                            section: 'Username',
                            text: profile.username.isNotEmpty
                                ? profile.username
                                : '...',
                            onPressed: () => editField('username')),
                        DetailBox(
                            section: 'Email',
                            text: profile.email.toString().isNotEmpty
                                ? profile.email.toString()
                                : '...'),
                        DetailBox(
                            section: 'Alamat',
                            text: profile.alamat.isNotEmpty
                                ? profile.alamat
                                : '...',
                            onPressed: () => editField('alamat')),
                        DetailBox(
                          section: 'No. Telp',
                          text: profile.noTelp.isNotEmpty
                              ? profile.noTelp
                              : '...',
                          onPressed: () => editField('noTelp'),
                        ),
                        DetailBox(
                            section: 'Tanggal Lahir',
                            text: profile.tanggalLahir.isNotEmpty
                                ? profile.tanggalLahir
                                : '...',
                            onPressed: () => editField('tanggalLahir')),
                        DetailBox(
                            section: 'Jenis Kelamin',
                            text: profile.jenisKelamin.isNotEmpty
                                ? profile.jenisKelamin
                                : '...',
                            onPressed: () => editField('jenisKelamin')),
                        //
                        const SizedBox(height: 24.0),
                        //
                        Text(
                          "Preferensi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) =>
                              SwitchListTile.adaptive(
                            title: Text(
                              'Dark Mode',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onChanged: (val) {
                              notifier.toggleChangeTheme(val);
                            },
                            value: notifier.darkMode!,
                          ),
                        )
                      ]),
                ),
              );
          }
        },
      ),
    );
  }
}
