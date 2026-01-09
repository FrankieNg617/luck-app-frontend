import 'package:flutter/material.dart';
import 'models/daily_response.dart';
import 'services/api.dart';

void main() {
  runApp(const FortuneApp());
}

class FortuneApp extends StatelessWidget {
  const FortuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Fortune',
      theme: ThemeData(useMaterial3: true),
      home: const DailyDashboardPage(),
    );
  }
}

class DailyDashboardPage extends StatefulWidget {
  const DailyDashboardPage({super.key});

  @override
  State<DailyDashboardPage> createState() => _DailyDashboardPageState();
}

class _DailyDashboardPageState extends State<DailyDashboardPage> {
  // TODO: Replace with your saved userId + timezone logic later
  final String userId = 'PUT_YOUR_USER_ID_HERE';
  final String tz = 'Asia/Tokyo';

  // Android emulator: 10.0.2.2
  final api = ApiService(baseUrl: 'http://10.0.2.2:3000');

  late Future<DailyResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = api.fetchDailyPersonal(userId: userId, tz: tz);
  }

  void _reload({bool refresh = false}) {
    setState(() {
      _future = api.fetchDailyPersonal(userId: userId, tz: tz, refresh: refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Daily Fortune'),
        actions: [
          IconButton(
            tooltip: 'Refresh (dev)',
            onPressed: () => _reload(refresh: true),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<DailyResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _reload(refresh: false),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _OverallCard(data),
                const SizedBox(height: 12),
                _ScoresGrid(data.scores),
                const SizedBox(height: 12),
                _LuckExtrasCard(data.dailyContent),
                const SizedBox(height: 12),
                _AdviceCard(data.dailyContent),
                const SizedBox(height: 12),
                _DoAvoidCard(data.dailyContent),
                const SizedBox(height: 12),
                _TasksCard(data.dailyContent),
                const SizedBox(height: 12),
                _ExplanationsCard(data.explanations),
                const SizedBox(height: 24),
                Text(
                  'Cached: ${data.meta.cached} • Date: ${data.meta.localDate}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  final DailyResponse data;
  const _OverallCard(this.data);

  @override
  Widget build(BuildContext context) {
    final overall = data.scores.overall;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall Luck', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('$overall / 100', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: overall / 100.0),
            const SizedBox(height: 8),
            if (data.natalSummary != null)
              Text(
                'Sun: ${data.natalSummary!.sunSign} • Moon: ${data.natalSummary!.moonSign} • Rising: ${data.natalSummary!.risingSign}',
              ),
          ],
        ),
      ),
    );
  }
}

class _ScoresGrid extends StatelessWidget {
  final Scores scores;
  const _ScoresGrid(this.scores);

  @override
  Widget build(BuildContext context) {
    Widget tile(String label, int value) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('$value', style: Theme.of(context).textTheme.headlineMedium),
                LinearProgressIndicator(value: value / 100.0),
              ],
            ),
          ),
        );

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: [
        tile('Career', scores.career),
        tile('Fortune', scores.fortune),
        tile('Love', scores.love),
        tile('Social', scores.social),
        tile('Study', scores.study),
        tile('Overall', scores.overall),
      ],
    );
  }
}

class _LuckExtrasCard extends StatelessWidget {
  final DailyContent c;
  const _LuckExtrasCard(this.c);

  @override
  Widget build(BuildContext context) {
    final nums = c.luckyNumbers.join(', ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lucky Extras', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Lucky Color: ${c.luckyColor}'),
            Text('Lucky Numbers: $nums'),
            Text('Lucky Time: ${c.luckyTime}'),
            const SizedBox(height: 8),
            Text('Lucky Food: ${c.luckyFood}'),
          ],
        ),
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final DailyContent c;
  const _AdviceCard(this.c);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Life Advice', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(c.lifeAdvice),
          ],
        ),
      ),
    );
  }
}

class _DoAvoidCard extends StatelessWidget {
  final DailyContent c;
  const _DoAvoidCard(this.c);

  @override
  Widget build(BuildContext context) {
    Widget bulletList(List<String> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((e) => Text('• $e')).toList(),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Do & Avoid', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Suggested to do', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            bulletList(c.suggestToDo),
            const SizedBox(height: 10),
            Text('Avoid doing', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            bulletList(c.avoidToDo),
          ],
        ),
      ),
    );
  }
}

class _TasksCard extends StatelessWidget {
  final DailyContent c;
  const _TasksCard(this.c);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...c.dailyTasks.map((t) => CheckboxListTile(
                  value: false,
                  onChanged: (_) {},
                  title: Text(t),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
          ],
        ),
      ),
    );
  }
}

class _ExplanationsCard extends StatelessWidget {
  final List<String> explanations;
  const _ExplanationsCard(this.explanations);

  @override
  Widget build(BuildContext context) {
    if (explanations.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why today?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...explanations.map((e) => Text('• $e')),
          ],
        ),
      ),
    );
  }
}
