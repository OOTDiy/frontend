import 'package:flutter/material.dart';
import '../../widgets/profile_avatar.dart';
import 'package:untitled1/featurs/accounts/signin.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const ProfileAvatar(), // foto profil
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Karina',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Arahkan ke edit_profile.dart
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Edit Profil"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                              (route) => false, // Hapus semua halaman sebelumnya
                        );
                      },
                      icon: const Icon(Icons.logout, size: 16),
                      label: const Text("Sign Out"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
