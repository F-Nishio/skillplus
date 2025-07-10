import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerScreen extends StatefulWidget {
  const CountdownTimerScreen({super.key});

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  int _initialMinutes = 1;
  int _initialSeconds = 0;
  late int _totalInitialSeconds;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _updateInitialSeconds();
  }

  void _updateInitialSeconds() {
    _totalInitialSeconds = _initialMinutes * 60 + _initialSeconds;
    _remainingSeconds = _totalInitialSeconds;
  }

  void _startTimer() {
    if (_isRunning || _remainingSeconds == 0) return;
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalInitialSeconds;
      _isRunning = false;
    });
  }

  void _selectTime() async {
    int selectedHours = _initialMinutes ~/ 60;
    int selectedMinutes = _initialMinutes % 60;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('時間を設定'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: selectedHours,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedHours = value;
                    });
                  }
                },
                items: List.generate(24, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('$index 時'),
                  );
                }),
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: selectedMinutes,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMinutes = value;
                    });
                  }
                },
                items: List.generate(60, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('$index 分'),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _initialMinutes = selectedHours * 60 + selectedMinutes;
                  _initialSeconds = 0;
                  _updateInitialSeconds();
                });
                Navigator.of(context).pop();
              },
              child: const Text('設定'),
            ),
          ],
        );
      },
    );
  }

  double get _progress {
    if (_totalInitialSeconds == 0) return 0;
    return _remainingSeconds / _totalInitialSeconds;
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/calendar');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text(
                  _formattedTime,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? '一時停止' : '開始'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('リセット'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isRunning ? null : _selectTime,
              icon: const Icon(Icons.edit),
              label: const Text('時間を設定'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'カレンダー',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer),
          label: 'タイマー',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'タスク',
        ),
      ],
    );
  }
}
