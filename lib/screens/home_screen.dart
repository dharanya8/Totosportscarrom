import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'toss_screen.dart';
import 'profile_screen.dart';
import './live_match_screen.dart'

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userPhone;

  const HomeScreen({super.key, required this.userName, required this.userPhone});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const LiveScreen(),
      const TossScreen(),
      ProfileScreen(userName: widget.userName, userPhone: widget.userPhone),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A472A),
          selectedItemColor: const Color(0xFFD4AF37),
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Toss'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
