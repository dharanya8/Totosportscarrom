import 'package:flutter/material.dart';
import 'user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 60, color: Colors.white),
                  Text(UserModel.name, style: const TextStyle(color: Colors.white)),
                  Text(UserModel.phone, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(onPressed: () {}, child: const Text("My Teams")),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: () {}, child: const Text("Create Teams")),
          ],
        ),
      ),
    );
  }
}
