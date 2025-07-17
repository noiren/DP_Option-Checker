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
    final flipLabel = flipOption == FlipType.flip ? 'FLIP' : '';
    return [laneLabel, assistLabel, flipLabel].where((s) => s.isNotEmpty).join(' / ');
  }
}

/// 曲＋３つのオプションをまとめた構造
class OptionList {
  final String songTitle;
  final DifficultyType difficulty;
  Option option1;
  Option option2;
  Option option3;

  OptionList({
    required this.songTitle,
    required this.difficulty,
    required this.option1,
    required this.option2,
    required this.option3,
  });

  /// 一行表示用ロジック
  String get displayText {
    // 難易度文字列
    String diffLabel;
    switch (difficulty) {
      case DifficultyType.beginner:
        diffLabel = 'BEGINNER';
        break;
      case DifficultyType.normal:
        diffLabel = 'NORMAL';
        break;
      case DifficultyType.hyper:
        diffLabel = 'HYPER';
        break;
      case DifficultyType.another:
        diffLabel = 'ANOTHER';
        break;
      case DifficultyType.leggendaria:
        diffLabel = 'LEGGENDARIA';
        break;
    }

    // 全裸判定
    final bothSRan = option1.leftLaneOption == LaneOptionType.sRan &&
        option1.rightLaneOption == LaneOptionType.sRan &&
        option2.leftLaneOption == LaneOptionType.sRan &&
        option2.rightLaneOption == LaneOptionType.sRan;
    final anyLegacy = option1.assistPlayOption == AssistPlayType.legacy ||
        option2.assistPlayOption == AssistPlayType.legacy;
    final anyFlip = option1.flipOption == FlipType.flip ||
        option2.flipOption == FlipType.flip;

    String optionLabel;
    if (bothSRan && anyLegacy && anyFlip) {
      optionLabel = '全裸';
    } else if (bothSRan && anyFlip) {
      optionLabel = '脳筋義正';
    } else if (bothSRan) {
      optionLabel = '脳筋正義';
    } else {
      // 通常は３つ分を結合
      optionLabel =
      '${option1.toLabel()} | ${option2.toLabel()} | ${option3.toLabel()}';
    }

    return '$songTitle | ($diffLabel) | $optionLabel';
  }
}