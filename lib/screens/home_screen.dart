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
  DifficultyType? selectedDifficulty;

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

  @override
  Widget build(BuildContext context) {
    final filtered = allItems.where((e) {
      final matchesSearch = e.songTitle.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedDifficulty == null || e.difficulty == selectedDifficulty;
      return matchesSearch && matchesFilter;
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
              onPressed: _showFilterDialog,
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
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: const Icon(Icons.music_note, color: Colors.cyanAccent, size: 32),
              title: Text(entry.songTitle, style: const TextStyle(fontSize: 18)),
              subtitle: Text(
                '${entry.difficulty.name.toUpperCase()} | $optionLabel',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
              onTap: () async {
                final updated = await showDialog<List<Option>>(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => EditDialog(initialOptions: entry.options),
                );
                if (updated != null && updated.isNotEmpty) {
                  setState(() {
                    final orig = allItems.firstWhere((e) => e.songTitle == entry.songTitle);
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('難易度でフィルタ'),
          content: DropdownButton<DifficultyType?>(
            isExpanded: true,
            value: selectedDifficulty,
            hint: const Text('全て表示'),
            items: [
              const DropdownMenuItem<DifficultyType?>(value: null, child: Text('全て表示')),
              ...DifficultyType.values.map((d) => DropdownMenuItem(
                value: d,
                child: Text(d.name.toUpperCase()),
              ))
            ],
            onChanged: (v) {
              setState(() {
                selectedDifficulty = v;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
