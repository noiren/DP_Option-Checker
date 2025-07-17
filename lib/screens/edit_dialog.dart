// lib/screens/edit_dialog.dart

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
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // コピーしていじれるように
    options = widget.initialOptions
        .map((o) => Option(
      leftLaneOption: o.leftLaneOption,
      rightLaneOption: o.rightLaneOption,
      assistPlayOption: o.assistPlayOption,
      flipOption: o.flipOption,
    ))
        .toList();
  }

  void _toggleEdit() {
    setState(() => isEditing = true);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _save() {
    Navigator.of(context).pop(options);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ヘッダー
            Row(
              children: [
                const Expanded(
                  child: Text('オプション確認', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (!isEditing) ...[
                  IconButton(icon: const Icon(Icons.edit), onPressed: _toggleEdit),
                ] else ...[
                  TextButton(onPressed: _cancel, child: const Text('キャンセル')),
                  IconButton(icon: const Icon(Icons.check), onPressed: _save),
                ],
              ],
            ),

            const Divider(),
            const SizedBox(height: 8),

            // 本体
            if (!isEditing) ...[
              // 閲覧モード：ラベルを３行で表示
              for (var opt in options)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(opt.toLabel(), style: const TextStyle(fontSize: 16)),
                ),
            ] else ...[
              // 編集モード：それぞれプルダウン
              for (int i = 0; i < options.length; i++) ...[
                // 左レーン
                DropdownButtonFormField<LaneOptionType>(
                  value: options[i].leftLaneOption,
                  decoration: InputDecoration(labelText: '左レーン ${i + 1}', border: const OutlineInputBorder()),
                  items: LaneOptionType.values.map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel()))).toList(),
                  onChanged: (v) => setState(() => options[i].leftLaneOption = v!),
                ),
                const SizedBox(height: 8),
                // 右レーン
                DropdownButtonFormField<LaneOptionType>(
                  value: options[i].rightLaneOption,
                  decoration: InputDecoration(labelText: '右レーン ${i + 1}', border: const OutlineInputBorder()),
                  items: LaneOptionType.values.map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel()))).toList(),
                  onChanged: (v) => setState(() => options[i].rightLaneOption = v!),
                ),
                const SizedBox(height: 8),
                // アシスト
                DropdownButtonFormField<AssistPlayType>(
                  value: options[i].assistPlayOption,
                  decoration: InputDecoration(labelText: 'アシスト ${i + 1}', border: const OutlineInputBorder()),
                  items: AssistPlayType.values.map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel()))).toList(),
                  onChanged: (v) => setState(() => options[i].assistPlayOption = v!),
                ),
                const SizedBox(height: 8),
                // FLIP
                DropdownButtonFormField<FlipType>(
                  value: options[i].flipOption,
                  decoration: InputDecoration(labelText: 'FLIP ${i + 1}', border: const OutlineInputBorder()),
                  items: FlipType.values.map((v) => DropdownMenuItem(value: v, child: Text(v.toLabel()))).toList(),
                  onChanged: (v) => setState(() => options[i].flipOption = v!),
                ),
                const Divider(height: 24),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// enum の toLabel() 拡張
extension on LaneOptionType {
  String toLabel() {
    switch (this) {
      case LaneOptionType.off:
        return 'OFF';
      case LaneOptionType.ran:
        return 'RAN';
      case LaneOptionType.rRan:
        return 'R‑RAN';
      case LaneOptionType.sRan:
        return 'S‑RAN';
      case LaneOptionType.mir:
        return 'MIR';
    }
  }
}

extension on AssistPlayType {
  String toLabel() {
    switch (this) {
      case AssistPlayType.off:
        return 'OFF';
      case AssistPlayType.aScr:
        return 'A‑SCR';
      case AssistPlayType.legacy:
        return 'LEGACY';
      case AssistPlayType.aScrLegacy:
        return 'A‑SCR/LEGACY';
    }
  }
}

extension on FlipType {
  String toLabel() {
    return this == FlipType.flip ? 'FLIP' : 'OFF';
  }
}