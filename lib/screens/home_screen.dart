import 'package:flutter/material.dart';

import '../background/home_background.dart';
import '../store/home_data_store.dart';
import '../widgets/Luck_Score/aspect_bars_widget.dart';
import '../widgets/Luck_Score/daily_tasks_widget.dart';
import '../widgets/Luck_Score/dos_donts_widget.dart';
import '../widgets/Luck_Score/header_widget.dart';
import '../widgets/Luck_Score/life_advice_widget.dart';
import '../widgets/Luck_Score/lucky_items_widget.dart';
import '../widgets/Luck_Score/overall_score_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.homeDataStore,
  });

  final HomeDataStore homeDataStore;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: homeDataStore,
      builder: (context, _) {
        if (homeDataStore.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (homeDataStore.error != null) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  homeDataStore.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }

        final data = homeDataStore.data!;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: HomeBackground(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    children: [
                      HeaderWidget(
                        username: data.username,
                        zodiac: data.zodiac,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OverallScoreWidget(score: data.overall),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AspectBarsWidget(
                              career: data.career,
                              study: data.study,
                              love: data.love,
                              social: data.social,
                              fortune: data.fortune,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      LifeAdviceWidget(advice: data.advice),
                      const SizedBox(height: 20),
                      LuckyItemsWidget(
                        food: data.food,
                        numbers: data.numbers,
                        colour: data.colour,
                        time: data.time,
                      ),
                      const SizedBox(height: 20),
                      DosDontsWidget(
                        dos: data.dos,
                        donts: data.donts,
                      ),
                      const SizedBox(height: 20),
                      DailyTasksWidget(initialTasks: data.tasks),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}