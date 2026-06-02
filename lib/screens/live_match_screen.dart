// lib/screens/live_match_screen.dart

import 'package:flutter/material.dart';
import 'toss_screen.dart'; // Add this import

class LiveMatchScreen extends StatefulWidget {
  final bool isDoubles;
  final String tossWinner;
  final String selectedCoin;

  const LiveMatchScreen({
    super.key,
    required this.isDoubles,
    required this.tossWinner,
    required this.selectedCoin,
  });

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> with SingleTickerProviderStateMixin {
  // Singles mode variables
  int _player1Score = 0;
  int _player2Score = 0;
  int _currentTurn = 1;

  // Doubles mode variables
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _currentPlayerIndex = 0;
  final List<String> _doublesTurnOrder = ["A1", "B1", "A2", "B2"];

  bool _queenPocketed = false;
  int _queenCount = 0;
  int _timeLeft = 180;

  late AnimationController _scoreAnimationController;
  final List<String> _actionLog = [];
  final List<Map<String, dynamic>> _undoStack = [];

  @override
  void initState() {
    super.initState();

    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeGame();
    _startTimer();
  }

  void _initializeGame() {
    if (widget.isDoubles) {
      if (widget.tossWinner == "Team A") {
        _currentPlayerIndex = 0;
        _addToHistory('🎲 Team A won the toss and will start with A1');
      } else {
        _currentPlayerIndex = 1;
        _addToHistory('🎲 Team B won the toss and will start with B1');
      }
      _addToHistory('🎯 ${widget.selectedCoin} coin selected for ${widget.tossWinner}');
      _addToHistory('📋 Turn Order: A1 → B1 → A2 → B2');
    } else {
      if (widget.tossWinner == "Player 1") {
        _currentTurn = 1;
        _addToHistory('🎲 Player 1 won the toss and will start');
      } else {
        _currentTurn = 2;
        _addToHistory('🎲 Player 2 won the toss and will start');
      }
      _addToHistory('🎯 ${widget.selectedCoin} coin selected for ${widget.tossWinner}');
    }

    _saveState();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
        _startTimer();
      }
    });
  }

  void _saveState() {
    _undoStack.add({
      'isDoubles': widget.isDoubles,
      'player1Score': _player1Score,
      'player2Score': _player2Score,
      'teamAScore': _teamAScore,
      'teamBScore': _teamBScore,
      'queenPocketed': _queenPocketed,
      'queenCount': _queenCount,
      'currentTurn': _currentTurn,
      'currentPlayerIndex': _currentPlayerIndex,
    });

    if (_undoStack.length > 20) {
      _undoStack.removeAt(0);
    }
  }

  // Update the _updateScore method and add a new method for foul

  void _updateScore(int increment, {bool isQueen = false}) {
    setState(() {
      _saveState();

      if (isQueen) {
        if (!_queenPocketed) {
          _queenPocketed = true;
          _queenCount++;

          if (widget.isDoubles) {
            String currentTeam = _getCurrentTeam();
            if (currentTeam == 'A') {
              _teamAScore += 3;
              _addToHistory('👑 Queen pocketed by ${_getCurrentPlayerName()} (+3 for Team A)');
            } else {
              _teamBScore += 3;
              _addToHistory('👑 Queen pocketed by ${_getCurrentPlayerName()} (+3 for Team B)');
            }
          } else {
            if (_currentTurn == 1) {
              _player1Score += 3;
            } else {
              _player2Score += 3;
            }
            _addToHistory('👑 Queen pocketed by Player $_currentTurn (+3)');
          }

          // Queen pocketed - turn changes
          _nextTurn();
        } else {
          _addToHistory('⚠️ Queen already pocketed!');
        }
      } else {
        if (widget.isDoubles) {
          String currentTeam = _getCurrentTeam();
          if (currentTeam == 'A') {
            _teamAScore += increment;
            if (_teamAScore < 0) _teamAScore = 0;
            _addToHistory(
              'Team A ${increment > 0 ? "+$increment" : "$increment"} points (${_getCurrentPlayerName()})',
            );
          } else {
            _teamBScore += increment;
            if (_teamBScore < 0) _teamBScore = 0;
            _addToHistory(
              'Team B ${increment > 0 ? "+$increment" : "$increment"} points (${_getCurrentPlayerName()})',
            );
          }
        } else {
          if (_currentTurn == 1) {
            _player1Score += increment;
            if (_player1Score < 0) _player1Score = 0;
          } else {
            _player2Score += increment;
            if (_player2Score < 0) _player2Score = 0;
          }
          _addToHistory(
            'Player $_currentTurn ${increment > 0 ? "+$increment" : "$increment"} points',
          );
        }

        // If it's a foul (negative increment), change turn
        if (increment < 0) {
          _nextTurn();
        }
      }

      _scoreAnimationController.forward(from: 0);
    });
  }

  void _wrongCoinPocket() {
    _saveState();

    setState(() {
      if (widget.isDoubles) {
        String currentTeam = _getCurrentTeam();
        if (currentTeam == 'A') {
          _teamAScore--;
          if (_teamAScore < 0) _teamAScore = 0;
          _addToHistory("❌ Wrong Coin (-1) for Team A by ${_getCurrentPlayerName()}");
        } else {
          _teamBScore--;
          if (_teamBScore < 0) _teamBScore = 0;
          _addToHistory("❌ Wrong Coin (-1) for Team B by ${_getCurrentPlayerName()}");
        }
      } else {
        if (_currentTurn == 1) {
          _player1Score--;
          if (_player1Score < 0) _player1Score = 0;
          _addToHistory("❌ Player 1 pocketed opponent coin (-1)");
        } else {
          _player2Score--;
          if (_player2Score < 0) _player2Score = 0;
          _addToHistory("❌ Player 2 pocketed opponent coin (-1)");
        }
      }

      _nextTurn();
    });
  }

  void _strikerFoul() {
    _saveState();

    setState(() {
      if (widget.isDoubles) {
        String currentTeam = _getCurrentTeam();
        if (currentTeam == 'A') {
          _teamAScore--;
          if (_teamAScore < 0) _teamAScore = 0;
          _addToHistory("⚠️ Striker Foul (-1) for Team A by ${_getCurrentPlayerName()}");
        } else {
          _teamBScore--;
          if (_teamBScore < 0) _teamBScore = 0;
          _addToHistory("⚠️ Striker Foul (-1) for Team B by ${_getCurrentPlayerName()}");
        }
      } else {
        if (_currentTurn == 1) {
          _player1Score--;
          if (_player1Score < 0) _player1Score = 0;
        } else {
          _player2Score--;
          if (_player2Score < 0) _player2Score = 0;
        }
        _addToHistory("⚠️ Player $_currentTurn striker foul (-1)");
      }

      _nextTurn();
    });
  }

  void _missShot() {
    _saveState();

    setState(() {
      _addToHistory(
        widget.isDoubles
            ? "🎯 ${_getCurrentPlayerName()} missed shot"
            : "🎯 Player $_currentTurn missed shot",
      );

      _nextTurn();
    });
  }

  void _nextTurn() {
    if (widget.isDoubles) {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _doublesTurnOrder.length;
      _addToHistory('🔄 Turn: ${_doublesTurnOrder[_currentPlayerIndex]}');
    } else {
      _currentTurn = _currentTurn == 1 ? 2 : 1;
      _addToHistory('🔄 Turn changed to Player $_currentTurn');
    }
  }

  void _changeTurn() {
    setState(() {
      _saveState();
      _nextTurn();
    });
  }

  void _undoLastAction() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        final lastState = _undoStack.removeLast();

        _player1Score = lastState['player1Score'];
        _player2Score = lastState['player2Score'];
        _teamAScore = lastState['teamAScore'];
        _teamBScore = lastState['teamBScore'];
        _queenPocketed = lastState['queenPocketed'];
        _queenCount = lastState['queenCount'];
        _currentTurn = lastState['currentTurn'];
        _currentPlayerIndex = lastState['currentPlayerIndex'];

        _addToHistory('↩️ Last action undone');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nothing to undo")));
    }
  }

  void _resetGame() {
    setState(() {
      _player1Score = 0;
      _player2Score = 0;
      _teamAScore = 0;
      _teamBScore = 0;
      _queenPocketed = false;
      _queenCount = 0;
      _actionLog.clear();
      _undoStack.clear();

      _initializeGame();
      _addToHistory('🔄 Game Reset');
    });
  }

  void _goBackToToss() {
    // Show confirmation dialog before going back
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Exit Match?', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to exit? Your match progress will be lost.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TossScreen()),
                );
              },
              child: const Text('Exit', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _getCurrentTeam() {
    return _doublesTurnOrder[_currentPlayerIndex][0];
  }

  String _getCurrentPlayerName() {
    if (widget.isDoubles) {
      return _doublesTurnOrder[_currentPlayerIndex];
    } else {
      return "Player $_currentTurn";
    }
  }

  void _addToHistory(String action) {
    _actionLog.insert(0, action);
    if (_actionLog.length > 10) {
      _actionLog.removeLast();
    }
  }

  String get _formattedTime {
    final minutes = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goBackToToss();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          title: const Text('Live Match'),
          backgroundColor: const Color(0xFF1E293B),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBackToToss),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetGame,
              tooltip: 'Reset Game',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [_buildScoreboard(), _buildRefereePanel(), _buildStrikeHistory()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF6C3BFF), Color(0xFF00BFFF)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: const Text(
              'LIVE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
            ),
          ),
          Column(
            children: [
              const Text(
                'Board #04',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.isDoubles ? 'DOUBLES MATCH' : 'SINGLES MATCH',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                _formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreboard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.3)),
      ),
      child: widget.isDoubles ? _buildDoublesScoreboard() : _buildSinglesScoreboard(),
    );
  }

  Widget _buildSinglesScoreboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPlayerCard(
              name: 'Player ${_currentTurn == 1 ? "★" : ""} 1',
              score: _player1Score,
              isActive: _currentTurn == 1,
              color: const Color(0xFF6C3BFF),
              coin: widget.tossWinner == "Player 1"
                  ? widget.selectedCoin
                  : (widget.selectedCoin == "White" ? "Black" : "White"),
            ),
            const Text(
              'VS',
              style: TextStyle(color: Color(0xFF22D3EE), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildPlayerCard(
              name: 'Player ${_currentTurn == 2 ? "★" : ""} 2',
              score: _player2Score,
              isActive: _currentTurn == 2,
              color: const Color(0xFF00BFFF),
              coin: widget.tossWinner == "Player 2"
                  ? widget.selectedCoin
                  : (widget.selectedCoin == "White" ? "Black" : "White"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildQueenStatus(),
      ],
    );
  }

  Widget _buildDoublesScoreboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTeamCard(
              teamName: 'TEAM A',
              players: 'A1 & A2',
              score: _teamAScore,
              isActive: _getCurrentTeam() == 'A',
              color: const Color(0xFF6C3BFF),
            ),
            const Text(
              'VS',
              style: TextStyle(color: Color(0xFF22D3EE), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildTeamCard(
              teamName: 'TEAM B',
              players: 'B1 & B2',
              score: _teamBScore,
              isActive: _getCurrentTeam() == 'B',
              color: const Color(0xFF00BFFF),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF22D3EE).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF22D3EE)),
          ),
          child: Text(
            'Current Turn: ${_doublesTurnOrder[_currentPlayerIndex]}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
        _buildQueenStatus(),
      ],
    );
  }

  Widget _buildTeamCard({
    required String teamName,
    required String players,
    required int score,
    required bool isActive,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(colors: [color.withOpacity(0.3), Colors.transparent])
            : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? color : Colors.white24, width: isActive ? 2 : 1),
      ),
      child: Column(
        children: [
          Text(
            teamName,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(players, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _scoreAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + (_scoreAnimationController.value * 0.2),
                child: Text(
                  score.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int score,
    required bool isActive,
    required Color color,
    required String coin,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(colors: [color.withOpacity(0.3), Colors.transparent])
            : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? color : Colors.white24, width: isActive ? 2 : 1),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(coin, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _scoreAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + (_scoreAnimationController.value * 0.2),
                child: Text(
                  score.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQueenStatus() {
    if (_queenPocketed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 16, color: Colors.green),
            SizedBox(width: 6),
            Text('Queen Pocketed', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.yellow),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium, size: 16, color: Colors.yellow),
            SizedBox(width: 6),
            Text('Queen Available (+3)', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }
  }

  Widget _buildRefereePanel() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'REFEREE PANEL',
                style: TextStyle(color: Colors.white54, letterSpacing: 1),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
                onPressed: _resetGame,
                tooltip: 'Reset Game',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 🔥 GRID STYLE BUTTONS (ROW + COLUMN STYLE)
          Wrap(
            spacing: 10, // horizontal space
            runSpacing: 10, // vertical space
            children: [
              _buildActionButton('+1 Coin', Icons.add, () => _updateScore(1)),
              // _buildActionButton('+2 Coins', Icons.add_circle, () => _updateScore(2)),
              _buildActionButton(
                '+3 Queen',
                Icons.workspace_premium,
                () => _updateScore(3, isQueen: true),
              ),
              _buildActionButton('-1 Foul', Icons.warning, () => _updateScore(-1)),
              _buildActionButton('Wrong Coin', Icons.warning_amber, _wrongCoinPocket),
              _buildActionButton('Striker Foul', Icons.sports, _strikerFoul),
              _buildActionButton('Miss Shot', Icons.cancel, _missShot),
              _buildActionButton('Turn Change', Icons.swap_horiz, _changeTurn),
              _buildActionButton('Undo', Icons.undo_outlined, _undoLastAction),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C3BFF).withOpacity(0.8),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStrikeHistory() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('STRIKE HISTORY', style: TextStyle(color: Colors.white54, letterSpacing: 1)),
          const SizedBox(height: 12),
          ..._actionLog
              .take(5)
              .map(
                (action) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: Color(0xFF22D3EE)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          action,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (_actionLog.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('No strikes recorded yet', style: TextStyle(color: Colors.white38)),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }
}
