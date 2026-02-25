import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZodiacSign {
  const ZodiacSign({
    required this.name,
    required this.symbol,
    required this.dates,
  });

  final String name;
  final String symbol;
  final String dates;
}

enum DropdownExpandDirection { up, down }

class ZodiacSelector extends StatefulWidget {
  const ZodiacSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.signs,
    required this.placeholder,
    this.height = 56,
    this.maxVisibleItems = 5,
    this.expandDirection = DropdownExpandDirection.down,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<ZodiacSign> signs;
  final String placeholder;

  /// Trigger height (responsive from parent)
  final double height;

  /// How many items to show before scrolling
  final int maxVisibleItems;

  /// Force menu to open above or below trigger
  final DropdownExpandDirection expandDirection;

  @override
  State<ZodiacSelector> createState() => _ZodiacSelectorState();
}

class _ZodiacSelectorState extends State<ZodiacSelector> {
  final LayerLink _link = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _entry;

  bool get _isOpen => _entry != null;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
      return;
    }
    _showOverlay();
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final size = box.size;

    final w = MediaQuery.of(context).size.width;
    final s = (w / 390.0).clamp(0.85, 1.2);

    double clamp(double v, double min, double max) =>
        v.clamp(min, max).toDouble();

    final itemH = clamp(48.0 * s, 44, 54);
    final maxH = itemH * widget.maxVisibleItems + 8; // small padding
    final radius = clamp(16.0 * s, 14, 20);

    // Offset from trigger: down opens right under; up opens right above
    final offset = widget.expandDirection == DropdownExpandDirection.down
        ? Offset(0, size.height + 8)
        : Offset(0, -(maxH + 8));

    _entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // tap outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
            ),

            // the anchored menu
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: offset,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: size.width,
                    maxWidth: size.width,
                    maxHeight: maxH,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1A1526,
                          ).withValues(alpha: 0.78),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 26,
                              spreadRadius: 0,
                              offset: const Offset(0, 12),
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                          ],
                        ),
                        child: CupertinoScrollbar(
                          thickness: 3,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(4),
                            physics: const BouncingScrollPhysics(),
                            itemExtent: itemH,
                            itemCount: widget.signs.length,
                            itemBuilder: (context, i) {
                              final sign = widget.signs[i];
                              final selected = sign.name == widget.value;

                              return _ZodiacMenuItem(
                                sign: sign,
                                selected: selected,
                                onTap: () {
                                  widget.onChanged(sign.name);
                                  _removeOverlay();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final s = (w / 390.0).clamp(0.85, 1.2);

    double clamp(double v, double min, double max) =>
        v.clamp(min, max).toDouble();

    final labelSize = clamp(11.0 * s, 10, 13);
    final textSize = clamp(16.0 * s, 14, 18);
    final symbolSize = clamp(22.0 * s, 18, 26);
    final radius = clamp(16.0 * s, 14, 20);

    final selected = widget.signs.cast<ZodiacSign?>().firstWhere(
      (z) => z?.name == widget.value,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: labelSize,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.60),
          ),
        ),
        const SizedBox(height: 8),

        // Anchor ONLY the trigger, so "expand up" goes right above the selector
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: _toggleOverlay,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              key: _triggerKey,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: _isOpen ? 0.10 : 0.07),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: _isOpen
                      ? const Color(0xFFE4547B).withValues(alpha: 0.50)
                      : Colors.white.withValues(alpha: 0.14),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (selected != null) ...[
                    Text(
                      selected.symbol,
                      style: TextStyle(fontSize: symbolSize),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selected.name,
                        style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.94),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      selected.dates,
                      style: TextStyle(
                        fontSize: clamp(12.0 * s, 10, 13),
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        widget.placeholder,
                        style: TextStyle(
                          fontSize: textSize,
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 160),
                    turns: _isOpen ? 0.5 : 0.0,
                    child: Icon(
                      CupertinoIcons.chevron_down,
                      size: clamp(18.0 * s, 16, 20),
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ZodiacMenuItem extends StatelessWidget {
  const _ZodiacMenuItem({
    required this.sign,
    required this.selected,
    required this.onTap,
  });

  final ZodiacSign sign;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final s = (w / 390.0).clamp(0.85, 1.2);

    double clamp(double v, double min, double max) =>
        v.clamp(min, max).toDouble();

    final symbolSize = clamp(20.0 * s, 18, 24);
    final nameSize = clamp(15.0 * s, 14, 17);
    final datesSize = clamp(12.0 * s, 10, 13);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE4547B).withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(sign.symbol, style: TextStyle(fontSize: symbolSize)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                sign.name,
                style: TextStyle(
                  fontSize: nameSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              sign.dates,
              style: TextStyle(
                fontSize: datesSize,
                color: Colors.white.withValues(alpha: 0.55),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            if (selected)
              Icon(
                CupertinoIcons.check_mark,
                size: clamp(18.0 * s, 16, 20),
                color: const Color(0xFFE4547B).withValues(alpha: 0.95),
              ),
          ],
        ),
      ),
    );
  }
}
