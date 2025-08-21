// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// //fireベース初期化
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Firebase初期化のために必要
//   await Firebase.initializeApp();            // Firebase初期化
// }
// // void main()  {
// //   runApp(const MyApp());
// // }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'タスク管理',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.grey,
//           foregroundColor: Colors.white,
//         ),
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//       ),
//       home: const GoalListPage(),
//       routes: {
//         '/calendar': (context) => const PlaceholderScreen(title: 'カレンダー'),
//         '/task': (context) => const PlaceholderScreen(title: 'タスク'),
//       },
//     );
//   }
// }
//
// class GoalListPage extends StatefulWidget {
//   const GoalListPage({super.key});
//
//   @override
//   State<GoalListPage> createState() => _GoalListPageState();
// }
//
// class _GoalListPageState extends State<GoalListPage> {
//   final List<String> _goals = [];
//   final Map<String, Map<String, bool>> _tasksPerGoal = {};
//   final Set<String> _expandedGoals = {};
//   int _currentIndex = 0;
//   void _onBottomNavTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//
//     // 画面遷移処理を記述（適宜修正）
//     if (index == 0) {
//       Navigator.pushReplacementNamed(context, '/calendar');
//     } else if (index == 2) {
//       Navigator.pushReplacementNamed(context, '/task');
//     }
//   }
//
//   void _showAddGoalModal() {
//     final TextEditingController goalController = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   '新しい目標を入力してください',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 TextField(
//                   controller: goalController,
//                   decoration: const InputDecoration(labelText: '目標名'),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     final goal = goalController.text.trim();
//                     if (goal.isNotEmpty) {
//                       setState(() {
//                         _goals.add(goal);
//                         _tasksPerGoal[goal] = {};
//                       });
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const Text('追加'),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _toggleExpanded(String goal) {
//     setState(() {
//       if (_expandedGoals.contains(goal)) {
//         _expandedGoals.remove(goal);
//       } else {
//         _expandedGoals.add(goal);
//       }
//     });
//   }
//
//   void _toggleTaskCheck(String goal, String task) {
//     setState(() {
//       _tasksPerGoal[goal]![task] = !_tasksPerGoal[goal]![task]!;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('目標一覧'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onBottomNavTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'カレンダー',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.timer),
//             label: 'タイマー',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'タスク',
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton.icon(
//               onPressed: _showAddGoalModal,
//               icon: const Icon(Icons.add),
//               label: const Text('目標を追加'),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: _goals.isEmpty
//                   ? const Center(
//                 child: Text(
//                   'まだ目標が登録されていません。',
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               )
//                   : ListView.builder(
//                 itemCount: _goals.length,
//                 itemBuilder: (context, index) {
//                   final goal = _goals[index];
//                   final taskMap = _tasksPerGoal[goal] ?? {};
//                   final isExpanded = _expandedGoals.contains(goal);
//
//                   final totalTasks = taskMap.length;
//                   final completedTasks = taskMap.values
//                       .where((completed) => completed)
//                       .length;
//
//                   return Card(
//                     child: Column(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.flag),
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(goal),
//                               if (totalTasks > 0)
//                                 Text(
//                                   '$completedTasks/$totalTasks 達成！',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           trailing: Icon(
//                             isExpanded
//                                 ? Icons.expand_less
//                                 : Icons.expand_more,
//                           ),
//                           onTap: () => _toggleExpanded(goal),
//                         ),
//                         if (isExpanded) ...[
//                           ...taskMap.entries.map(
//                                 (entry) => CheckboxListTile(
//                               title: Text(
//                                 entry.key,
//                                 style: TextStyle(
//                                   decoration: entry.value
//                                       ? TextDecoration.lineThrough
//                                       : null,
//                                 ),
//                               ),
//                               value: entry.value,
//                               onChanged: (_) =>
//                                   _toggleTaskCheck(goal, entry.key),
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: TextButton.icon(
//                               onPressed: () => _showAddTaskModal(goal),
//                               icon: const Icon(Icons.add),
//                               label: const Text('タスクを追加'),
//                             ),
//                           ),
//                           const Divider(),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16.0),
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton.icon(
//                                 onPressed: () => _toggleExpanded(goal),
//                                 icon: const Icon(Icons.close),
//                                 label: const Text(''),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showAddTaskModal(String goal) {
//     final List<TextEditingController> taskControllers = [
//       TextEditingController()
//     ];
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             top: 20,
//             left: 20,
//             right: 20,
//           ),
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setModalState) {
//               return ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.6,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('$goal に新しいタスクを追加',
//                         style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 10),
//
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children:
//                           List.generate(taskControllers.length, (index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 8),
//                               child: TextField(
//                                 controller: taskControllers[index],
//                                 decoration: InputDecoration(
//                                   labelText: 'タスク名 ${index + 1}',
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//
//                     // ＋ボタンを右下に配置
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10, bottom: 20),
//                         child: FloatingActionButton(
//                           mini: true,
//                           onPressed: () {
//                             setModalState(() {
//                               taskControllers.add(TextEditingController());
//                             });
//                           },
//                           child: const Icon(Icons.add),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     ElevatedButton(
//                       onPressed: () {
//                         final tasks = taskControllers
//                             .map((c) => c.text.trim())
//                             .where((text) => text.isNotEmpty)
//                             .toList();
//
//                         if (tasks.isNotEmpty) {
//                           setState(() {
//                             for (var task in tasks) {
//                               _tasksPerGoal[goal]?[task] = false;
//                             }
//                           });
//                           Navigator.pop(context);
//                         }
//                       },
//                       child: const Text('追加'),
//                     ),
//
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// //仮
// class PlaceholderScreen extends StatelessWidget {
//   final String title;
//   const PlaceholderScreen({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(child: Text('$title ページ')),
//     );
//   }
// }