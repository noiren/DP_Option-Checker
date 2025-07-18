// 完全版 option_entry.dart （toLabel 拡張 & null安全対応）

/// 難易度の列挙型
enum DifficultyType {
  beginner,
  normal,
  hyper,
  another,
  leggendaria,
}

/// レーンオプションの列挙型
enum LaneOptionType {
  off,
  ran,
  rRan,
  sRan,
  mir,
}

/// アシストプレイの列挙型
enum AssistPlayType {
  off,
  aScr,
  legacy,
  aScrLegacy,
}

/// FLIP の列挙型
enum FlipType {
  off,
  flip,
}

extension LaneOptionTypeExtension on LaneOptionType {
  String toLabel() {
    switch (this) {
      case LaneOptionType.off: return 'OFF';
      case LaneOptionType.ran: return 'RAN';
      case LaneOptionType.rRan: return 'R‑RAN';
      case LaneOptionType.sRan: return 'S‑RAN';
      case LaneOptionType.mir: return 'MIR';
    }
  }
}

extension AssistPlayTypeExtension on AssistPlayType {
  String toLabel() {
    switch (this) {
      case AssistPlayType.off: return 'OFF';
      case AssistPlayType.aScr: return 'A‑SCR';
      case AssistPlayType.legacy: return 'LEGACY';
      case AssistPlayType.aScrLegacy: return 'A‑SCR/LEGACY';
    }
  }
}

extension FlipTypeExtension on FlipType {
  String toLabel() {
    return this == FlipType.flip ? 'FLIP' : 'OFF';
  }
}

/// 単一オプション構造
class Option {
  LaneOptionType leftLaneOption;
  LaneOptionType rightLaneOption;
  AssistPlayType assistPlayOption;
  FlipType flipOption;

  Option({
    required this.leftLaneOption,
    required this.rightLaneOption,
    required this.assistPlayOption,
    required this.flipOption,
  });

  String toLabel() {
    final laneLabel = '${leftLaneOption.toLabel()} / ${rightLaneOption.toLabel()}';
    final assistLabel = assistPlayOption.toLabel();
    final flipLabel = flipOption.toLabel();
    return [laneLabel, assistLabel, flipLabel].where((s) => s.isNotEmpty).join(' / ');
  }
}

class OptionList {
  final String songTitle;
  final DifficultyType difficulty;
  final String? version;
  final int? level;
  final int? bpm;
  List<Option> options;

  OptionList({
    required this.songTitle,
    required this.difficulty,
    this.version,
    this.level,
    this.bpm,
    required this.options,
  });

  String get displayText {
    final diffLabel = _diffToString(difficulty);
    final labels = options.map((o) => o.toLabel()).toList();
    final body = labels.join(' | ');
    return '$songTitle | ($diffLabel) | $body';
  }

  String _diffToString(DifficultyType d) {
    switch (d) {
      case DifficultyType.beginner: return 'BEGINNER';
      case DifficultyType.normal: return 'NORMAL';
      case DifficultyType.hyper: return 'HYPER';
      case DifficultyType.another: return 'ANOTHER';
      case DifficultyType.leggendaria: return 'LEGGENDARIA';
    }
  }

  factory OptionList.fromJson(Map<String, dynamic> json) {
    return OptionList(
      songTitle: json['SongTitle'] as String,
      difficulty: DifficultyType.values.firstWhere(
            (e) => e.name.toLowerCase() == json['Difficulty'].toString().toLowerCase(),
        orElse: () => DifficultyType.normal,
      ),
      version: json['Version'] as String?,
      level: json['Level'] is int ? json['Level'] as int : int.tryParse(json['Level']?.toString() ?? ''),
      bpm: json['BPM'] is int ? json['BPM'] as int : int.tryParse(json['BPM']?.toString() ?? ''),
      options: [
        Option(
          leftLaneOption: LaneOptionType.off,
          rightLaneOption: LaneOptionType.off,
          assistPlayOption: AssistPlayType.off,
          flipOption: FlipType.off,
        )
      ],
    );
  }
}

extension OptionListFactory on OptionList {
  static OptionList fromJson(Map<String, dynamic> json) => OptionList.fromJson(json);
}
