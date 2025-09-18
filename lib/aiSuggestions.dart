import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 縦向き
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
  // // Firebase初期化
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // runApp(const schedule_proposal());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEPHROLITHIASIS',
      debugShowCheckedModeBanner: false,
      darkTheme:ThemeData.dark() ,
      home: MyPage(title: 'ONE PHRASE DIARY'),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.title});

  final String title;

  @override
  _schedule_proposalState createState() => _schedule_proposalState();
}

class _schedule_proposalState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スケジュール提案'),
        // backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: '受験予定日',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '教材',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '学習ペース(平日)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: '学習ペース(休日)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                // Icon(Icons.schedule, color: Colors.deepPurple),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // スケジュール提案処理
                  },
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('スケジュール提案'),
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.deepPurple,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  int _currentIndex = 1; // タイマーを中央に配置（インデックス1）
  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
