import 'package:flutter/material.dart';
import '../models/option_entry.dart';

class EditDialog extends StatefulWidget {
  final List<Option> initialOptions;
  const EditDialog({super.key, required this.initialOptions});
  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late List<Option> options;
  int? editingIndex; // 編集中の行番号。null=閲覧モード

  @override
  void initState() {
    super.initState();
    options = widget.initialOptions
        .map((o) => Option(
        leftLaneOption: o.leftLaneOption,
        rightLaneOption: o.rightLaneOption,
        assistPlayOption: o.assistPlayOption,
        flipOption: o.flipOption))
        .toList();
  }

  void _startEdit(int i) => setState(() => editingIndex = i);
  void _cancelEdit()      => setState(() => editingIndex = null);

  void _saveAll() {
    Navigator.of(context).pop(options);
  }

  void _addOption() {
    if (options.length < 3) {
      setState(() {
        options.add(Option(
          leftLaneOption: LaneOptionType.off,
          rightLaneOption: LaneOptionType.off,
          assistPlayOption: AssistPlayType.off,
          flipOption: FlipType.off,
        ));
        editingIndex = options.length - 1; // 追加直後にその行を編集
      });
    }
  }

  void _deleteOption(int i) {
    setState(() {
      options.removeAt(i);
      if (editingIndex == i) {
        editingIndex = null;
      } else if (editingIndex != null && editingIndex! > i) {
        editingIndex = editingIndex! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 20)],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

          // ヘッダー
          Row(children: [
            const Expanded(child: Text('オプション編集', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(icon: const Icon(Icons.check), onPressed: _saveAll),
          ]),
          const Divider(),

          // 各オプション行
          ...List.generate(options.length, (i) {
            final opt = options[i];
            final isEditing = editingIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(children: [
                // ラベル or 編集UI
                Expanded(
                  child: isEditing
                      ? _buildOptionEditor(i)
                      : Text(opt.toLabel(), style: const TextStyle(fontSize: 16)),
                ),

                // 編集／キャンセルボタン
                if (isEditing)
                  IconButton(icon: const Icon(Icons.close), onPressed: _cancelEdit)
                else
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => _startEdit(i)),

                // 削除ボタン（2つ目以降かつ編集中でないときだけ）
                if (i > 0 && options.length > 1 && editingIndex != i)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteOption(i),
                  ),
              ]),
            );
          }),

          // 追加ボタン
          if (options.length < 3)
            TextButton.icon(
              onPressed: _addOption,
              icon: const Icon(Icons.add),
              label: const Text('オプションを追加'),
            ),
        ]),
      ),
    );
  }

  /// 行ごとの編集UI（プルダウン4つ）
  Widget _buildOptionEditor(int i) {
    return Column(children: [
      DropdownButtonFormField<LaneOptionType>(
        value: options[i].leftLaneOption,
        decoration: const InputDecoration(labelText: '左レーン', border: OutlineInputBorder()),
        items: LaneOptionType.values
            .map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel())))
            .toList(),
        onChanged: (v) => setState(() => options[i].leftLaneOption = v!),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<LaneOptionType>(
        value: options[i].rightLaneOption,
        decoration: const InputDecoration(labelText: '右レーン', border: OutlineInputBorder()),
        items: LaneOptionType.values
            .map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel())))
            .toList(),
        onChanged: (v) => setState(() => options[i].rightLaneOption = v!),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<AssistPlayType>(
        value: options[i].assistPlayOption,
        decoration: const InputDecoration(labelText: 'アシスト', border: OutlineInputBorder()),
        items: AssistPlayType.values
            .map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel())))
            .toList(),
        onChanged: (v) => setState(() => options[i].assistPlayOption = v!),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<FlipType>(
        value: options[i].flipOption,
        decoration: const InputDecoration(labelText: 'FLIP', border: OutlineInputBorder()),
        items: FlipType.values
            .map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel())))
            .toList(),
        onChanged: (v) => setState(() => options[i].flipOption = v!),
      ),
    ]);
  }
}