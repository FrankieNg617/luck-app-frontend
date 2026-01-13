import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class DailyTasksWidget extends StatefulWidget {
  final List<String> initialTasks;
  const DailyTasksWidget({super.key, required this.initialTasks});

  @override
  State<DailyTasksWidget> createState() => _DailyTasksWidgetState();
}

class _DailyTasksWidgetState extends State<DailyTasksWidget>
    with SingleTickerProviderStateMixin {
  late List<_Task> tasks;

  late final AnimationController _entryController;
  late final Animation<double> _entryCurve;

  @override
  void initState() {
    super.initState();
    tasks = _buildTasks(widget.initialTasks, previous: const []);

    // ✅ entry animation (once per widget creation)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entryCurve = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );
    _entryController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  // ✅ This runs when parent passes a new initialTasks list
  @override
  void didUpdateWidget(covariant DailyTasksWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the list content changed, rebuild internal tasks
    if (!_sameStringList(oldWidget.initialTasks, widget.initialTasks)) {
      setState(() {
        tasks = _buildTasks(widget.initialTasks, previous: tasks);
      });
    }
  }

  // Preserve completion status when possible (match by text)
  List<_Task> _buildTasks(List<String> incoming, {required List<_Task> previous}) {
    return List.generate(incoming.length, (i) {
      final text = incoming[i];
      final prev = previous.where((t) => t.text == text).toList();
      final completed = prev.isNotEmpty ? prev.first.completed : false;
      return _Task(id: i, text: text, completed: completed);
    });
  }

  bool _sameStringList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void toggleTask(int id) {
    setState(() {
      final idx = tasks.indexWhere((t) => t.id == id);
      if (idx >= 0) {
        tasks[idx] = tasks[idx].copyWith(completed: !tasks[idx].completed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((t) => t.completed).length;

    return AnimatedBuilder(
      animation: _entryCurve,
      builder: (context, _) {
        final t = _entryCurve.value; // 0..1

        return Transform.translate(
          offset: Offset(0, (1 - t) * 35), // slide up
          child: Opacity(
            opacity: t, // fade in
            child: Container(
              decoration: FortuneTheme.cardDecoration(),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_border, size: 22, color: FortuneTheme.gold),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Daily Tasks',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 255, 255, 255), // Title
                          ),
                        ),
                      ),
                      Text(
                        '$completedCount/${tasks.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 255, 255, 255), // 1/3
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 14),
                  Column(
                    children: tasks
                        .map((t) => _TaskRow(task: t, onTap: () => toggleTask(t.id)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Task {
  final int id;
  final String text;
  final bool completed;

  _Task({required this.id, required this.text, required this.completed});

  _Task copyWith({bool? completed}) =>
      _Task(id: id, text: text, completed: completed ?? this.completed);
}

class _TaskRow extends StatelessWidget {
  final _Task task;
  final VoidCallback onTap;
  const _TaskRow({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = task.completed
        ? FortuneTheme.gold
        : const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.25);

    final border = task.completed
        ? FortuneTheme.gold.withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.18);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.completed ? FortuneTheme.gold : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(width: 2, color: borderColor),
                ),
                child: task.completed
                    ? const Icon(Icons.check, size: 16, color: Color.fromARGB(255, 54, 52, 52))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    color: task.completed
                        ? const Color.fromARGB(255, 141, 129, 129)
                        : const Color.fromARGB(255, 255, 255, 255),
                    decoration:
                        task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
