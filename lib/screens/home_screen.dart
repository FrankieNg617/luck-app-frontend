import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/score_preview_widget.dart';
import '../background/galaxy_background_comic.dart';
import 'luck_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const overall = 78;
    const career = 72;
    const study = 66;
    const love = 81;
    const social = 70;
    const fortune = 76;

    return GalaxyBackgroundComic(
      child: Scaffold(
        backgroundColor: Colors
            .transparent, 
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: 14),

                ScorePreviewWidget(
                  overallScore: overall,
                  career: career,
                  study: study,
                  love: love,
                  social: social,
                  fortune: fortune,
                  onOpenLuck: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LuckScreen()),
                    );
                  },
                ),

                const SizedBox(height: 18),
                // other home widgets here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
