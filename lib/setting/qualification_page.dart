// qualification_page.dart
import 'package:flutter/material.dart';

class QualificationPage extends StatefulWidget {
  const QualificationPage({super.key});

  @override
  State<QualificationPage> createState() => _QualificationPageState();
}

class _QualificationPageState extends State<QualificationPage> {
  final List<Map<String, String>> _qualifications = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _exaController = TextEditingController();
  int? _editingIndex;
  int _currentIndex = 1; // タイマーを中央に配置（インデックス1）

  void _addOrUpdateQualification() {
    final name = _nameController.text;
    final date = _dateController.text;
    final exa = _exaController.text;
    if (name.isEmpty || date.isEmpty || exa.isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        _qualifications[_editingIndex!] = {'name': name, 'date': date, 'exa': exa};
        _editingIndex = null;
      } else {
        _qualifications.add({'name': name, 'date': date, 'exa': exa});
      }
      _nameController.clear();
      _dateController.clear();
      _exaController.clear();
    });
  }

  void _editQualification(int index) {
    setState(() {
      _nameController.text = _qualifications[index]['name']!;
      _dateController.text = _qualifications[index]['date']!;
      _exaController.text = _qualifications[index]['exa']!;
      _editingIndex = index;
    });
    _showQualificationDialog();
  }

  void _showQualificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingIndex == null ? '資格を追加' : '資格を編集'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: '取得年月'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '資格名'),
            ),
            TextField(
              controller: _exaController,
              decoration: const InputDecoration(labelText: '備考'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              _dateController.clear();
              _exaController.clear();
              _editingIndex = null;
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              _addOrUpdateQualification();
              Navigator.pop(context);
            },
            child: Text(_editingIndex == null ? '追加' : '更新'),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 画面遷移処理を記述（適宜修正）
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/calendar');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/task');
    }
  }

  // 歯車アイコンのポップアップメニュー
  void _showSettingsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 60, 60, 0, 0), // 右上に表示
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'profile',
          child: Text('プロフィール'),
        ),
        const PopupMenuItem(
          value: 'qualifications',
          child: Text('取得資格一覧'),
        ),
      ],
    ).then((value) {
      if (value == 'profile') {
        // プロフィール画面への遷移
        Navigator.pushReplacementNamed(context, '/profile'); // プロフィールページのルート名
      } else if (value == 'qualifications') {
        // 取得資格一覧画面への遷移 (現在のページなので、特に何もしないか、あるいは同じページを再表示)
        // 必要に応じて Navigator.pushReplacementNamed(context, '/qualification'); などを追加
        print('取得資格一覧が選択されました'); // デバッグ用
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('取得資格一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // 歯車アイコン
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _editingIndex = null;
                    _nameController.clear();
                    _dateController.clear();
                    _exaController.clear();
                    _showQualificationDialog();
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  // 表形式のタイトル行
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('取得年月', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('資格名', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text('備考', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 48), // 編集アイコン分のスペース確保
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _qualifications.length,
                      itemBuilder: (context, index) {
                        final qual = _qualifications[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(qual['date'] ?? ''),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(qual['name'] ?? ''),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(qual['exa'] ?? ''),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editQualification(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ▼▼▼ ボトムバーここから ▼▼▼
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
      // ▲▲▲ ボトムバーここまで ▲▲▲
    );
  }
}