import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../popup/zodiac_stage_popup.dart';

class ZodiacInfoWidget extends StatelessWidget {
  const ZodiacInfoWidget({
    super.key,
    required this.sign,
  });

  final String sign;

  // You will paste real text later. Keep placeholders for now.
  // Each sign -> 3 stages (button label + popup body)
  static final Map<String, List<_StageData>> _stageBySign = {
    'Aries': const [
      _StageData(label: 'Stage 1: Starter Flame', body: 'Paste Aries stage 1 passage here.'),
      _StageData(label: 'Stage 2: Bold Builder', body: 'Paste Aries stage 2 passage here.'),
      _StageData(label: 'Stage 3: Fearless Leader', body: 'Paste Aries stage 3 passage here.'),
    ],
    'Taurus': const [
      _StageData(label: 'Stage 1: Slow & Steady', body: 'Paste Taurus stage 1 passage here.'),
      _StageData(label: 'Stage 2: Solid Growth', body: 'Paste Taurus stage 2 passage here.'),
      _StageData(label: 'Stage 3: Strong Anchor', body: 'Paste Taurus stage 3 passage here.'),
    ],
    // TODO: Add the rest. For now we’ll fallback if missing.
  };

  List<_StageData> _stagesForSign(String sign) {
    final s = sign.trim();
    final stages = _stageBySign[s];
    if (stages != null && stages.length == 3) return stages;

    // Fallback (so UI never crashes while you're still filling data)
    return const [
      _StageData(label: 'Stage 1', body: 'Paste passage later.'),
      _StageData(label: 'Stage 2', body: 'Paste passage later.'),
      _StageData(label: 'Stage 3', body: 'Paste passage later.'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final scale = (math.min(w, h) / 390.0).clamp(0.85, 1.25);

    final cardWidth = (w * (0.80 * scale)).clamp(280.0, 580.0);
    final pad = (18.0 * scale).clamp(14.0, 26.0);

    final hPad = (16.0 * scale).clamp(12.0, 22.0);
    final vGapL = (14.0 * scale).clamp(10.0, 18.0);
    final vGapM = (10.0 * scale).clamp(8.0, 14.0);

    final headingSize = (18.0 * scale).clamp(16.0, 24.0);
    final bodySize = (14.0 * scale).clamp(12.5, 18.0);

    final buttonTextSize = (15.0 * scale).clamp(13.0, 20.0);
    final buttonHeight = (48.0 * scale).clamp(42.0, 58.0);

    final dividerInset = (2.0 * scale);
    final dividerThickness = (1.0 * scale).clamp(1.0, 1.5);

    final stages = _stagesForSign(sign);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: cardWidth),
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18.0 * scale),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Relationship (hardcoded title) =====
            Text(
              'Relationship',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            SizedBox(height: vGapM),

            // Placeholder content area (you haven't decided yet)
            Text(
              'Content coming soon…',
              style: TextStyle(
                fontSize: bodySize,
                color: Colors.white.withValues(alpha: 0.78),
                height: 1.6,
              ),
            ),

            SizedBox(height: vGapL),
            _InsetDivider(inset: dividerInset, thickness: dividerThickness),
            SizedBox(height: vGapL),

            // ===== Birthday Stages (hardcoded title) =====
            Text(
              'Birthday Stages',
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15,
              ),
            ),
            SizedBox(height: vGapM),

            // ===== 3 Vertical Buttons =====
            Column(
              children: List.generate(3, (i) {
                final item = stages[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: i == 2 ? 0 : (10.0 * scale).clamp(8.0, 14.0)),
                  child: SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: _StageButton(
                      label: item.label,
                      textSize: buttonTextSize,
                      hPad: hPad,
                      onTap: () {
                        ZodiacStagePopup.show(
                          context,
                          title: item.label,
                          body: item.body,
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageData {
  final String label;
  final String body;

  const _StageData({
    required this.label,
    required this.body,
  });
}

class _StageButton extends StatelessWidget {
  const _StageButton({
    required this.label,
    required this.onTap,
    required this.textSize,
    required this.hPad,
  });

  final String label;
  final VoidCallback onTap;
  final double textSize;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: textSize,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _InsetDivider extends StatelessWidget {
  const _InsetDivider({
    required this.inset,
    required this.thickness,
  });

  final double inset;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inset),
      child: Container(
        height: thickness,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
