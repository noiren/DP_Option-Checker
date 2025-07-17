import 'package:flutter/material.dart';
import '../models/option_entry.dart'; // OptionList, Option, 各 enum が定義されているファイル
import 'edit_dialog.dart';            // EditDialog が定義されているファイル

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // デフォルトOFFオプション
  final Option defaultOption = Option(
    leftLaneOption: LaneOptionType.off,
    rightLaneOption: LaneOptionType.off,
    assistPlayOption: AssistPlayType.off,
    flipOption: FlipType.off,
  );

  // 初期データ：options リストはまず defaultOption のみ
  List<OptionList> items = [
    OptionList(
      songTitle: 'Fascination MAXX',
      difficulty: DifficultyType.hyper,
      options: [ // 最初は1つだけ
        Option(
          leftLaneOption: LaneOptionType.off,
          rightLaneOption: LaneOptionType.off,
          assistPlayOption: AssistPlayType.off,
          flipOption: FlipType.off,
        ),
      ],
    ),
    // 必要なら 他の曲を同様に追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DP オプション一覧')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final entry = items[index];
          return ListTile(
            // タイトルは曲名のみ
            title: Text(entry.songTitle),
            // サブタイトルに Option1 のみ表示
            subtitle: Text(entry.options.first.toLabel()),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              // 現状の options リストをそのまま渡す
              final updated = await showDialog<List<Option>>(
                context: context,
                barrierDismissible: true,
                builder: (_) => EditDialog(initialOptions: entry.options),
              );

              // ダイアログで保存された場合は updated に要素が入っている
              if (updated != null && updated.isNotEmpty) {
                setState(() {
                  // 最大3つまでに制限して上書き
                  entry.options = updated.take(3).toList();
                });
              }
            },
          );
        },
      ),
    );
  }
}