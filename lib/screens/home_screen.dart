
import 'package:flutter/material.dart';
import '../models/option_entry.dart';
import 'edit_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // デフォルトOFFオプションを１つだけ保持
  final Option defaultOption = Option(
    leftLaneOption: LaneOptionType.off,
    rightLaneOption: LaneOptionType.off,
    assistPlayOption: AssistPlayType.off,
    flipOption: FlipType.off,
  );

  // 初期データ: optionsリストは最初 defaultOption のみ
  List<OptionList> items = [
    OptionList(
      songTitle: 'Fascination MAXX',
      difficulty: DifficultyType.hyper,
      options: [
        Option(
          leftLaneOption: LaneOptionType.off,
          rightLaneOption: LaneOptionType.off,
          assistPlayOption: AssistPlayType.off,
          flipOption: FlipType.off,
        ),
      ],
    ),
    // 他の曲を追加したい場合はここに同様のOptionListを追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DP オプション一覧')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final entry = items[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.music_note, color: Colors.cyanAccent, size: 32),
              title: Text(entry.songTitle, style: const TextStyle(fontSize: 18)),
              subtitle: Text(entry.options.first.toLabel(), style: const TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () async {
                // 現在の options リストを渡してダイアログを呼び出し
                final updated = await showDialog<List<Option>>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => EditDialog(initialOptions: entry.options),
                );

                // 保存された場合のみ、options を上書き（最大3つに制限）
                if (updated != null && updated.isNotEmpty) {
                  setState(() {
                    entry.options = updated.take(3).toList();
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
