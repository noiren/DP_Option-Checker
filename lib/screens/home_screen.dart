import 'package:flutter/material.dart';
import '../models/option_entry.dart';
import 'edit_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // デフォルトOFFオプション
  final Option defaultOption = Option(
    leftLaneOption: LaneOptionType.off,
    rightLaneOption: LaneOptionType.off,
    assistPlayOption: AssistPlayType.off,
    flipOption: FlipType.off,
  );

  // モックデータ
  List<OptionList> allItems = [
    OptionList(
      songTitle: 'Fascination MAXX',
      difficulty: DifficultyType.hyper,
      options: [Option(
        leftLaneOption: LaneOptionType.off,
        rightLaneOption: LaneOptionType.off,
        assistPlayOption: AssistPlayType.off,
        flipOption: FlipType.off,
      )],
    ),
    OptionList(
      songTitle: '冥',
      difficulty: DifficultyType.another,
      options: [Option(
        leftLaneOption: LaneOptionType.off,
        rightLaneOption: LaneOptionType.off,
        assistPlayOption: AssistPlayType.off,
        flipOption: FlipType.off,
      )],
    ),
    // 他の曲…
  ];

  // ユーザー入力に応じて絞り込む
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 検索文字列にマッチするものだけを表示
    final filtered = allItems
        .where((e) =>
        e.songTitle.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        // 高さを拡張して上に余白を確保
        toolbarHeight: 100,
        // 検索バーを下に20px下げる
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: '曲名で検索',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white54),
            ),
            onChanged: (v) => setState(() => searchQuery = v),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final entry = filtered[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.music_note,
                  color: Colors.cyanAccent, size: 32),
              title: Text(entry.songTitle,
                  style: const TextStyle(fontSize: 18)),
              subtitle: Text(entry.options.first.toLabel(),
                  style: const TextStyle(fontSize: 14)),
              trailing:
              const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () async {
                final updated = await showDialog<List<Option>>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => EditDialog(initialOptions: entry.options),
                );
                if (updated != null && updated.isNotEmpty) {
                  setState(() {
                    // 全アイテムを検索前データから更新
                    final orig = allItems.firstWhere(
                            (e) => e.songTitle == entry.songTitle);
                    orig.options = updated.take(3).toList();
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