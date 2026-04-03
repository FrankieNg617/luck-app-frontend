class HomeData {
  const HomeData({
    required this.username,
    required this.zodiac,
    required this.overall,
    required this.career,
    required this.study,
    required this.love,
    required this.social,
    required this.fortune,
    required this.advice,
    required this.dos,
    required this.donts,
    required this.tasks,
    required this.food,
    required this.numbers,
    required this.colour,
    required this.time,
  });

  final String username;
  final String zodiac;

  final int overall;
  final int career;
  final int study;
  final int love;
  final int social;
  final int fortune;

  final String advice;
  final List<String> dos;
  final List<String> donts;
  final List<String> tasks;

  final String food;
  final List<int> numbers;
  final String colour;
  final String time;
}