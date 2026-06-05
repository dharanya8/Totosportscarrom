import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'registration_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  const MainNavigationScreen({super.key, required this.userName, required this.userPhone});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),

      const RegistrationScreen(),

      ProfileScreen(userName: widget.userName, userPhone: widget.userPhone),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 15, color: Colors.black12)],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.white,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,

          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),

            BottomNavigationBarItem(icon: Icon(Icons.app_registration_rounded), label: "Register"),

            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
