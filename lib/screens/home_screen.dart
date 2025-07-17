// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/option_entry.dart';
import 'edit_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OptionList> items = [
    OptionList(
      songTitle: 'Fascination MAXX',
      difficulty: DifficultyType.hyper,
      option1: Option(
        leftLaneOption: LaneOptionType.sRan,
        rightLaneOption: LaneOptionType.sRan,
        assistPlayOption: AssistPlayType.legacy,
        flipOption: FlipType.flip,
      ),
      option2: Option(
        leftLaneOption: LaneOptionType.ran,
        rightLaneOption: LaneOptionType.off,
        assistPlayOption: AssistPlayType.off,
        flipOption: FlipType.off,
      ),
      option3: Option(
        leftLaneOption: LaneOptionType.mir,
        rightLaneOption: LaneOptionType.rRan,
        assistPlayOption: AssistPlayType.aScr,
        flipOption: FlipType.off,
      ),
    ),
    // 必要に応じてさらに追加…
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DP オプション一覧')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final entry = items[i];
          return ListTile(
            title: Text(entry.displayText),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              final updated = await showDialog<List<Option>>(
                context: context,
                barrierDismissible: true,
                builder: (_) => EditDialog(
                  initialOptions: [entry.option1, entry.option2, entry.option3],
                ),
              );
              if (updated != null && updated.length == 3) {
                setState(() {
                  items[i] = OptionList(
                    songTitle: entry.songTitle,
                    difficulty: entry.difficulty,
                    option1: updated[0],
                    option2: updated[1],
                    option3: updated[2],
                  );
                });
              }
            },
          );
        },
      ),
    );
  }
}