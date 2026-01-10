import 'package:flutter/material.dart';
import '../ui/fortune_style.dart';

class DailyTasksWidget extends StatefulWidget {
  final List<String> initialTasks;
  const DailyTasksWidget({super.key, required this.initialTasks});

  @override
  State<DailyTasksWidget> createState() => _DailyTasksWidgetState();
}

class _DailyTasksWidgetState extends State<DailyTasksWidget> {
  late List<_Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = _buildTasks(widget.initialTasks, previous: const []);
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

    return Container(
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: FortuneTheme.foreground,
                  ),
                ),
              ),
              Text(
                '$completedCount/${tasks.length}',
                style: TextStyle(fontSize: 13, color: FortuneTheme.mutedForeground),
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
        : FortuneTheme.mutedForeground.withOpacity(0.25);

    final bgColor = task.completed
        ? FortuneTheme.gold.withOpacity(0.10)
        : Colors.white.withOpacity(0.55);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
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
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
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
                        ? FortuneTheme.mutedForeground
                        : FortuneTheme.foreground,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
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
