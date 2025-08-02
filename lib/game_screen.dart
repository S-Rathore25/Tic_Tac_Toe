import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class GamePage extends StatefulWidget {
  final GameMode mode;
  const GamePage({super.key, required this.mode});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _statusMessage = '';
  bool _isGameOver = false;
  int? _winningLineIndex;
  bool _showWinningLine = false;

  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  @override
  void initState() {
    super.initState();
    _showPlayerSelectionDialog();
  }

  void _showPlayerSelectionDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Choose your player', textAlign: TextAlign.center),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isXTurn = true;
                      _statusMessage = 'Player X\'s Turn';
                    });
                    Navigator.of(context).pop();
                    _showGoodLuckMessage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('X', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isXTurn = false;
                      _statusMessage = 'Player O\'s Turn';
                    });
                    Navigator.of(context).pop();
                    _showGoodLuckMessage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('O', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showGoodLuckMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Good Luck!', textAlign: TextAlign.center),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleTap(int index) {
    if (_isGameOver || _board[index].isNotEmpty) {
      return;
    }

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _isXTurn = !_isXTurn;
      _statusMessage = _isXTurn ? 'Player X\'s Turn' : 'Player O\'s Turn';
    });

    _checkWinner();
  }

  void _checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var combo in winningCombinations) {
      if (_board[combo[0]].isNotEmpty &&
          _board[combo[0]] == _board[combo[1]] &&
          _board[combo[0]] == _board[combo[2]]) {
        setState(() {
          _isGameOver = true;
          _statusMessage = 'Player ${_board[combo[0]]} Wins!';
          _winningLineIndex = winningCombinations.indexOf(combo);
          _showWinningLine = true;
          if (_board[combo[0]] == 'X') {
            _xWins++;
          } else {
            _oWins++;
          }
        });
        _showWinnerDialog('Player ${_board[combo[0]]}');
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _isGameOver = true;
        _statusMessage = 'Draw!';
        _draws++;
      });
    }
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie_animations/celebrate.json',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                '$winner wins the game!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _statusMessage = 'Player X\'s Turn';
      _isGameOver = false;
      _showWinningLine = false;
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  Widget _buildWinningLine() {
    if (!_showWinningLine) {
      return const SizedBox.shrink();
    }

    double width = 0;
    double height = 0;
    double top = 0;
    double left = 0;
    double angle = 0;

    switch (_winningLineIndex) {
      case 0:
        width = 300; height = 8; top = 40; left = 0; angle = 0; break;
      case 1:
        width = 300; height = 8; top = 140; left = 0; angle = 0; break;
      case 2:
        width = 300; height = 8; top = 240; left = 0; angle = 0; break;
      case 3:
        width = 300; height = 8; top = 140; left = -100; angle = 90; break;
      case 4:
        width = 300; height = 8; top = 140; left = 0; angle = 90; break;
      case 5:
        width = 300; height = 8; top = 140; left = 100; angle = 90; break;
      case 6:
        width = 420; height = 8; top = 140; left = 0; angle = 45; break;
      case 7:
        width = 420; height = 8; top = 140; left = 0; angle = -45; break;
    }

    return Positioned(
      top: top,
      left: left,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: width,
          height: height,
          transform: Matrix4.rotationZ(angle * 3.14159 / 180),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Player X Wins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        Text('$_xWins', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Draws', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text('$_draws', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Player O Wins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                        Text('$_oWins', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isGameOver ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Stack(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _handleTap(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _board[index].isEmpty ? 0.0 : 1.0,
                                  child: Text(
                                    _board[index],
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: _board[index] == 'X' ? Colors.blueAccent : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildWinningLine(),
                  ],
                ),
                const SizedBox(height: 40),
                if (_isGameOver)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _resetGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _goBack,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
