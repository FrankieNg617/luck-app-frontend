import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/overall_score_widget.dart';
import '../widgets/aspect_bars_widget.dart';
import '../widgets/life_advice_widget.dart';
import '../widgets/lucky_items_widget.dart';
import '../widgets/dos_donts_widget.dart';
import '../widgets/daily_tasks_widget.dart';
import '../background/galaxy_background_comic.dart';

class LuckScreen extends StatelessWidget {
  const LuckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data (replace with backend API later)
    final overall = 78;
    final career = 70, study = 62, love = 85, social = 73, fortune = 66;

    final advice = "Stars can't shine without darkness.";

    final dos = ["Pause before tasks", "Take a slow walk"];
    final donts = ["Overthink decisions", "Skip meals"];

    final tasks = [
      "Send a kind message to someone you appreciate",
      "Take a 15-minute break to clear your mind",
      "Write down 3 things you're grateful for",
    ];

    final food = "Sushi";
    final numbers = [7, 42];
    final colour = "Gold";
    final time = "8AM-10AM";

    return Scaffold(
      body: GalaxyBackgroundComic(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                children: [
                  const HeaderWidget(),
                  const SizedBox(height: 18),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OverallScoreWidget(score: overall),
                      const SizedBox(width: 14),
                      Expanded(
                        child: AspectBarsWidget(
                          career: career,
                          study: study,
                          love: love,
                          social: social,
                          fortune: fortune,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),
                  LifeAdviceWidget(advice: advice),

                  const SizedBox(height: 20),
                  LuckyItemsWidget(
                    food: food,
                    numbers: numbers,
                    colour: colour,
                    time: time,
                  ),

                  const SizedBox(height: 20),
                  DosDontsWidget(dos: dos, donts: donts),

                  const SizedBox(height: 20),
                  DailyTasksWidget(initialTasks: tasks),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
