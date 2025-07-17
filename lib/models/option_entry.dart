// lib/models/option_entry.dart

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
  rRan,   // R‑RAN
  sRan,   // S‑RAN
  mir,
}

/// アシストプレイの列挙型
enum AssistPlayType {
  off,
  aScr,        // A‑SCR
  legacy,      // LEGACY
  aScrLegacy,  // A‑SCR/LEGACY
}

/// FLIP の列挙型
enum FlipType {
  off,
  flip,
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

  /// enum → 表示用文字列変換
  String toLabel() {
    String lane(LaneOptionType v) {
      switch (v) {
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
    String assist(AssistPlayType v) {
      switch (v) {
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
    final laneLabel = '${lane(leftLaneOption)} / ${lane(rightLaneOption)}';
    final assistLabel = assist(assistPlayOption);
    final flipLabel = flipOption == FlipType.flip ? 'FLIP' : 'OFF';
    return [laneLabel, assistLabel, flipLabel].where((s) => s.isNotEmpty).join(' / ');
  }
}

/// 曲＋３つのオプションをまとめた構造
class OptionList {
  final String songTitle;
  final DifficultyType difficulty;
  List<Option> options;

  OptionList({
    required this.songTitle,
    required this.difficulty,
    required this.options,
  });

  /// 一行表示用
  String get displayText {
    // 難易度
    String diffLabel = _diffToString(difficulty);

    // 先頭のオプションだけサブタイトルで見せたいときは
    // options.first.toLabel()

    // 一括表示用（全オプションを “ | ” で繋ぐ or キャッチ文言）
    // （全裸判定などはこの中でも可能です）
    final labels = options.map((o) => o.toLabel()).toList();
    final body = labels.join(' | ');

    return '$songTitle | ($diffLabel) | $body';
  }

  String _diffToString(DifficultyType d) {
    switch (d) {
      case DifficultyType.beginner:
        return 'BEGINNER';
      case DifficultyType.normal:
        return 'NORMAL';
      case DifficultyType.hyper:
        return 'HYPER';
      case DifficultyType.another:
        return 'ANOTHER';
      case DifficultyType.leggendaria:
        return 'LEGGENDARIA';
    }
  }
}

extension LaneOptionTypeExtension on LaneOptionType {
  String toLabel() {
    switch (this) {
      case LaneOptionType.off:  return 'OFF';
      case LaneOptionType.ran:  return 'RAN';
      case LaneOptionType.rRan: return 'R‑RAN';
      case LaneOptionType.sRan: return 'S‑RAN';
      case LaneOptionType.mir:  return 'MIR';
    }
  }
}

extension AssistPlayTypeExtension on AssistPlayType {
  String toLabel() {
    switch (this) {
      case AssistPlayType.off:        return 'OFF';
      case AssistPlayType.aScr:       return 'A‑SCR';
      case AssistPlayType.legacy:     return 'LEGACY';
      case AssistPlayType.aScrLegacy: return 'A‑SCR/LEGACY';
    }
  }
}

extension FlipTypeExtension on FlipType {
  String toLabel() {
    return this == FlipType.flip ? 'FLIP' : 'OFF';
  }
}