
import 'package:flutter/material.dart';
import '../models/option_entry.dart';
import 'edit_dialog.dart';

/// 曲名リストを検索し、選択するとダイアログで編集画面を呼び出す
class SongSearchDelegate extends SearchDelegate<OptionList?> {
  final List<OptionList> allItems;
  SongSearchDelegate(this.allItems);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? allItems
        : allItems
        .where((e) =>
        e.songTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(context, suggestions);
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allItems
        .where((e) =>
        e.songTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(context, results);
  }

  Widget _buildList(BuildContext context, List<OptionList> list) {
    if (list.isEmpty) {
      return const Center(child: Text('該当する曲がありません'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (c, i) {
        final entry = list[i];
        return ListTile(
          title: Text(entry.songTitle),
          subtitle: Text(entry.options.first.toLabel()),
          onTap: () {
            // 検索結果を返して画面を閉じる
            close(context, entry);
            // さらにダイアログを開く
            showDialog<List<Option>>(
              context: c,
              barrierDismissible: true,
              builder: (_) => EditDialog(initialOptions: entry.options),
            ).then((updated) {
              if (updated != null && updated.isNotEmpty) {
                entry.options = updated.take(3).toList();
                // 検索画面の背後にある HomeScreen も再描画
                (context as Element).markNeedsBuild();
              }
            });
          },
        );
      },
    );
  }
}
