class DailyResponse {
  final Meta meta;
  final Scores scores;
  final DailyContent dailyContent;
  final List<String> explanations;
  final NatalSummary? natalSummary;

  DailyResponse({
    required this.meta,
    required this.scores,
    required this.dailyContent,
    required this.explanations,
    this.natalSummary,
  });

  factory DailyResponse.fromJson(Map<String, dynamic> json) {
    return DailyResponse(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      scores: Scores.fromJson(json['scores'] as Map<String, dynamic>),
      dailyContent: DailyContent.fromJson(json['daily_content'] as Map<String, dynamic>),
      explanations: (json['explanations'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      natalSummary: json['natalSummary'] != null
          ? NatalSummary.fromJson(json['natalSummary'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Meta {
  final String userId;
  final String tz;
  final String localDate;
  final String anchoredLocalNoon;
  final bool cached;

  Meta({
    required this.userId,
    required this.tz,
    required this.localDate,
    required this.anchoredLocalNoon,
    required this.cached,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      userId: (json['userId'] ?? '').toString(),
      tz: (json['tz'] ?? '').toString(),
      localDate: (json['local_date'] ?? '').toString(),
      anchoredLocalNoon: (json['anchored_local_noon'] ?? '').toString(),
      cached: (json['cached'] ?? false) as bool,
    );
  }
}

class NatalSummary {
  final String sunSign;
  final String moonSign;
  final String risingSign;

  NatalSummary({required this.sunSign, required this.moonSign, required this.risingSign});

  factory NatalSummary.fromJson(Map<String, dynamic> json) {
    return NatalSummary(
      sunSign: (json['sunSign'] ?? '').toString(),
      moonSign: (json['moonSign'] ?? '').toString(),
      risingSign: (json['risingSign'] ?? '').toString(),
    );
  }
}

class Scores {
  final int overall;
  final int career;
  final int fortune;
  final int love;
  final int social;
  final int study;

  Scores({
    required this.overall,
    required this.career,
    required this.fortune,
    required this.love,
    required this.social,
    required this.study,
  });

  factory Scores.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) => (v is num) ? v.round() : int.tryParse(v.toString()) ?? 0;

    return Scores(
      overall: toInt(json['overall']),
      career: toInt(json['career']),
      fortune: toInt(json['fortune']),
      love: toInt(json['love']),
      social: toInt(json['social']),
      study: toInt(json['study']),
    );
  }
}

class DailyContent {
  final String lifeAdvice;
  final List<String> suggestToDo;
  final List<String> avoidToDo;
  final String luckyFood;
  final List<String> dailyTasks;
  final String luckyColor;
  final List<int> luckyNumbers;
  final String luckyTime;

  DailyContent({
    required this.lifeAdvice,
    required this.suggestToDo,
    required this.avoidToDo,
    required this.luckyFood,
    required this.dailyTasks,
    required this.luckyColor,
    required this.luckyNumbers,
    required this.luckyTime,
  });

  factory DailyContent.fromJson(Map<String, dynamic> json) {
    List<String> toStrList(dynamic v) =>
        (v as List<dynamic>? ?? []).map((e) => e.toString()).toList();

    List<int> toIntList(dynamic v) =>
        (v as List<dynamic>? ?? []).map((e) => (e is num) ? e.toInt() : int.parse(e.toString())).toList();

    return DailyContent(
      lifeAdvice: (json['life_advice'] ?? '').toString(),
      suggestToDo: toStrList(json['suggest_to_do']),
      avoidToDo: toStrList(json['avoid_to_do']),
      luckyFood: (json['lucky_food'] ?? '').toString(),
      dailyTasks: toStrList(json['daily_tasks']),
      luckyColor: (json['lucky_color'] ?? '').toString(),
      luckyNumbers: toIntList(json['lucky_numbers']),
      luckyTime: (json['lucky_time'] ?? '').toString(),
    );
  }
}
