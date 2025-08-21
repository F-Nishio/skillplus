// profile_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  File? _image;
  String _nickname = 'ニックネーム未設定';
  String _memo = '備考未設定';
  String _startDate = '未設定';
  int _currentIndex = 1;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSubmitted) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$titleを編集'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: '$titleを入力してください'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
          ElevatedButton(
            onPressed: () {
              onSubmitted(controller.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
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

  List<String> getTaskListFromOtherScreen() {
    // ここで実際にはProviderやSharedPreferences、DBなどを用いて取得する想定
    return ['Oracleの参考書読む', '筋トレ', '散歩', 'ヤクルト飲む']; // サンプルデータを増やしました
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
        // プロフィール画面への遷移 (現在のページなので、特に何もしないか、あるいは同じページを再表示)
        print('プロフィールが選択されました'); // デバッグ用
      } else if (value == 'qualifications') {
        // 取得資格一覧画面への遷移
        Navigator.pushReplacementNamed(context, '/qualification'); // 取得資格一覧ページのルート名
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> taskList = getTaskListFromOtherScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // 歯車アイコン
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.camera_alt, size: 30) : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _nickname,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('ニックネーム'),
            subtitle: Text(_nickname),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showEditDialog('ニックネーム', _nickname, (value) {
              setState(() => _nickname = value);
            }),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.note_alt_outlined),
            title: const Text('備考'),
            subtitle: Text(_memo),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showEditDialog('備考', _memo, (value) {
              setState(() => _memo = value);
            }),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('アプリ利用開始日'),
            subtitle: Text(_startDate),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showEditDialog('アプリ利用開始日', _startDate, (value) {
              setState(() => _startDate = value);
            }),
          ),
          const Divider(height: 1),
          // 完了したタスク一覧をExpansionTileで囲む
          ExpansionTile(
            leading: const Icon(Icons.check_box), // アイコンを追加
            title: const Text('完了したタスク一覧'),
            children: <Widget>[
              if (taskList.isEmpty) // タスクがない場合の表示
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('完了したタスクはありません。'),
                ),
              ...taskList.map((task) => ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: Text(task),
              )),
            ],
          ),
          const Divider(height: 1), // ExpansionTileの下にもDividerを追加
        ],
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
}