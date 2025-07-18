import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/option_entry.dart';
import 'edit_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<OptionList> allItems = [];
  String searchQuery = '';

  // フィルタ状態
  DifficultyType? selectedDifficulty;
  String? selectedVersion;
  int? selectedLevel;
  double bpmMin = 0;
  double bpmMax = 300;

  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  Future<void> _loadJsonFromAssets() async {
    final jsonStr = await rootBundle.loadString('assets/data/dp.json');
    final jsonList = jsonDecode(jsonStr) as List<dynamic>;
    setState(() {
      allItems = jsonList.map((e) => OptionListFactory.fromJson(e)).toList();
    });
  }

  void _resetAllFilters() {
    setState(() {
      selectedDifficulty = null;
      selectedVersion = null;
      selectedLevel = null;
      bpmMin = 0;
      bpmMax = 300;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allItems.where((e) {
      final matchesSearch = e.songTitle.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesDifficulty = selectedDifficulty == null || e.difficulty == selectedDifficulty;
      final matchesVersion = selectedVersion == null || e.version == selectedVersion;
      final matchesLevel = selectedLevel == null || e.level == selectedLevel;
      final bpmValue = e.bpm?.toDouble() ?? 0;
      final matchesBpm = bpmValue >= bpmMin && bpmValue <= bpmMax;
      return matchesSearch && matchesDifficulty && matchesVersion && matchesLevel && matchesBpm;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          children: [
            Expanded(
              child: Padding(
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
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: _showFilterPanel,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final entry = filtered[index];
          final optionLabel = entry.options.isNotEmpty ? entry.options.first.toLabel() : 'OFF';
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.cyanAccent),
              title: Text(entry.songTitle),
              subtitle: Text('${entry.difficulty.name.toUpperCase()} | $optionLabel'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final updated = await showDialog<List<Option>>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => EditDialog(initialOptions: entry.options),
                );
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

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final versions = allItems.map((e) => e.version).whereType<String>().toSet().toList();
        final levels = allItems.map((e) => e.level).whereType<int>().toSet().toList()..sort();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('フィルタ', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(onPressed: _resetAllFilters, child: const Text('リセット')),
                ],
              ),
              const Divider(color: Colors.white54),
              DropdownButtonFormField<DifficultyType?>(
                decoration: const InputDecoration(labelText: '難易度'),
                value: selectedDifficulty,
                items: [
                  const DropdownMenuItem<DifficultyType?>(value: null, child: Text('全て')),
                  ...DifficultyType.values.map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d.name.toUpperCase()),
                  )),
                ],
                onChanged: (v) => setState(() => selectedDifficulty = v),
              ),
              DropdownButtonFormField<String?>(
                decoration: const InputDecoration(labelText: 'バージョン'),
                value: selectedVersion,
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('全て')),
                  ...versions.map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v),
                  )),
                ],
                onChanged: (v) => setState(() => selectedVersion = v),
              ),
              DropdownButtonFormField<int?>(
                decoration: const InputDecoration(labelText: 'レベル'),
                value: selectedLevel,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('全て')),
                  ...levels.map((l) => DropdownMenuItem(
                    value: l,
                    child: Text(l.toString()),
                  )),
                ],
                onChanged: (v) => setState(() => selectedLevel = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'BPM最小'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        bpmMin = double.tryParse(v) ?? 0;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'BPM最大'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        bpmMax = double.tryParse(v) ?? 300;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
