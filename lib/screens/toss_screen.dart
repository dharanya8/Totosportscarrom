// lib/screens/toss_screen.dart

import 'package:flutter/material.dart';
import 'package:totocarrom/screens/login_screen.dart';
import 'live_match_screen.dart';

class TossScreen extends StatefulWidget {
  const TossScreen({super.key});

  @override
  State<TossScreen> createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> {
  // Match type selection
  String? matchType;

  // Singles variables
  String? singlesWinner;

  // Doubles variables
  String? doublesWinner;

  // Common coin selection
  String? selectedCoin;

  final coins = ["White", "Black"];

  void startMatch() {
    if (matchType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select match type first")));
      return;
    }

    if (matchType == 'singles' && singlesWinner == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select toss winner")));
      return;
    }

    if (matchType == 'doubles' && doublesWinner == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select toss winner")));
      return;
    }

    if (selectedCoin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select coin")));
      return;
    }

    String finalWinner = matchType == 'singles' ? singlesWinner! : doublesWinner!;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LiveMatchScreen(
          isDoubles: matchType == 'doubles',
          tossWinner: finalWinner,
          selectedCoin: selectedCoin!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("TOSS & COIN SELECTION"),
        backgroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView here
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Step 1: Select Match Type
              _buildMatchTypeSelector(),

              const SizedBox(height: 20),

              // Step 2: Select Toss Winner (based on match type)
              if (matchType != null) _buildTossWinnerSelector(),

              const SizedBox(height: 20),

              // Step 3: Select Coin
              if ((matchType == 'singles' && singlesWinner != null) ||
                  (matchType == 'doubles' && doublesWinner != null))
                _buildCoinSelector(),

              const SizedBox(height: 20),

              // Start Match Button
              if (matchType != null &&
                  ((matchType == 'singles' && singlesWinner != null) ||
                      (matchType == 'doubles' && doublesWinner != null)) &&
                  selectedCoin != null)
                _buildStartButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STEP 1: SELECT MATCH TYPE',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      matchType = 'singles';
                      singlesWinner = null;
                      doublesWinner = null;
                      selectedCoin = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: matchType == 'singles'
                          ? const LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)])
                          : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.02),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: matchType == 'singles'
                            ? const Color(0xFF00BFFF)
                            : Colors.white.withOpacity(0.1),
                        width: matchType == 'singles' ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 40,
                          color: matchType == 'singles' ? Colors.white : Colors.white70,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SINGLES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: matchType == 'singles' ? Colors.white : Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1 vs 1',
                          style: TextStyle(
                            fontSize: 12,
                            color: matchType == 'singles' ? Colors.white70 : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      matchType = 'doubles';
                      singlesWinner = null;
                      doublesWinner = null;
                      selectedCoin = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: matchType == 'doubles'
                          ? const LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)])
                          : LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.05),
                                Colors.white.withOpacity(0.02),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: matchType == 'doubles'
                            ? const Color(0xFF00BFFF)
                            : Colors.white.withOpacity(0.1),
                        width: matchType == 'doubles' ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group,
                          size: 40,
                          color: matchType == 'doubles' ? Colors.white : Colors.white70,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'DOUBLES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: matchType == 'doubles' ? Colors.white : Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2 vs 2',
                          style: TextStyle(
                            fontSize: 12,
                            color: matchType == 'doubles' ? Colors.white70 : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTossWinnerSelector() {
    if (matchType == 'singles') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STEP 2: SELECT TOSS WINNER',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSelectionBox(
                    label: "Player 1",
                    selected: singlesWinner,
                    color: Colors.blue,
                    onTap: () => setState(() => singlesWinner = "Player 1"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSelectionBox(
                    label: "Player 2",
                    selected: singlesWinner,
                    color: Colors.purple,
                    onTap: () => setState(() => singlesWinner = "Player 2"),
                  ),
                ),
              ],
            ),
            if (singlesWinner != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$singlesWinner won the toss and will choose coin first',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STEP 2: SELECT TOSS WINNER',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSelectionBox(
                    label: "Team A",
                    selected: doublesWinner,
                    color: Colors.blue,
                    onTap: () => setState(() => doublesWinner = "Team A"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSelectionBox(
                    label: "Team B",
                    selected: doublesWinner,
                    color: Colors.purple,
                    onTap: () => setState(() => doublesWinner = "Team B"),
                  ),
                ),
              ],
            ),
            if (doublesWinner != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$doublesWinner won the toss and will choose coin first',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '📋 TURN ORDER FOR DOUBLES',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'A1 → B1 → A2 → B2 → Repeat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'The toss winner decides who starts the game',
                            style: TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildCoinSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STEP 3: SELECT COIN',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: coins.map((coin) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedCoin = coin),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: selectedCoin == coin
                          ? const LinearGradient(colors: [Colors.green, Colors.lightGreen])
                          : null,
                      color: selectedCoin == coin ? null : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedCoin == coin ? Colors.green : Colors.grey.shade700,
                        width: selectedCoin == coin ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          coin == "White" ? Icons.circle : Icons.circle_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          coin,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedCoin != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        matchType == 'singles'
                            ? '$singlesWinner selected $selectedCoin coin and will start the match'
                            : '$doublesWinner selected $selectedCoin coin and will start the match',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionBox({
    required String label,
    required String? selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = selected == label;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [color, color.withOpacity(0.7)]) : null,
          color: isSelected ? null : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade700,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: startMatch,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "START MATCH",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
