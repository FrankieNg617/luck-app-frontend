import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../popup/zodiac_stage_popup.dart';
import '../data/zodiac_stage_data.dart';
import '../data/zodiac_relationship_data.dart';
import '../data/zodiac_relationship_detail.dart';

class ZodiacInfoWidget extends StatelessWidget {
  const ZodiacInfoWidget({super.key, required this.sign});

  final String sign;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    final scale = (math.min(w, h) / 390.0).clamp(0.55, 2.25);

    final cardWidth = (w * (0.85 * scale)).clamp(280.0, 580.0);
    final pad = (18.0 * scale).clamp(14.0, 26.0);

    final hPad = (16.0 * scale).clamp(12.0, 22.0);
    final vGapL = (16.0 * scale).clamp(10.0, 18.0);
    final vGapM = (12.0 * scale).clamp(8.0, 14.0);

    final headingSize = (18.0 * scale).clamp(16.0, 24.0);

    final buttonTextSize = (15.0 * scale).clamp(13.0, 20.0);
    final buttonHeight = (48.0 * scale).clamp(42.0, 58.0);

    final dividerInset = (2.0 * scale);
    final dividerThickness = (1.0 * scale).clamp(1.0, 1.5);

    final stages = ZodiacStageRepository.getStages(sign);

    // ===== RELATIONSHIP DATA  =====
    final relationship = ZodiacRelationshipRepository.getRelationships(sign);
    final loveValue = _joinList(relationship["love"]);
    final friendshipValue = _joinList(relationship["friendship"]);
    final sexValue = _joinList(relationship["sex"]);
    final workValue = _joinList(relationship["work"]);

    // Responsive styling for relationship rows
    final rowTitleSize = (16.0 * scale).clamp(5.0, 28.0);
    final rowValueSize = (16.0 * scale).clamp(5.0, 28.0);
    final rowGap = (13.0 * scale).clamp(8.0, 17.0);
    final lineThickness = (1.0 * scale).clamp(1.0, 1.6);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: cardWidth),
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 28, 38, 67),
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

            // ===== Relationship rows (TEST DATA) =====
            _RelationshipRow(
              icon: Icons.favorite_rounded,
              title: 'Love',
              value: loveValue,
              categoryKey: 'love',
              sign: sign,
              titleSize: rowTitleSize,
              valueSize: rowValueSize,
              lineThickness: lineThickness,
            ),
            SizedBox(height: rowGap),
            _RelationshipRow(
              icon: Icons.people_alt_rounded,
              title: 'Friendship',
              value: friendshipValue,
              categoryKey: 'friendship',
              sign: sign,
              titleSize: rowTitleSize,
              valueSize: rowValueSize,
              lineThickness: lineThickness,
            ),
            SizedBox(height: rowGap),
            _RelationshipRow(
              icon: Icons.local_fire_department_rounded,
              title: 'Sex',
              value: sexValue,
              categoryKey: 'sex',
              sign: sign,
              titleSize: rowTitleSize,
              valueSize: rowValueSize,
              lineThickness: lineThickness,
            ),
            SizedBox(height: rowGap),
            _RelationshipRow(
              icon: Icons.work_rounded,
              title: 'Work',
              value: workValue,
              categoryKey: 'work',
              sign: sign,
              titleSize: rowTitleSize,
              valueSize: rowValueSize,
              lineThickness: lineThickness,
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
                  padding: EdgeInsets.only(
                    bottom: i == 2 ? 0 : (10.0 * scale).clamp(8.0, 14.0),
                  ),
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

  static String _joinList(List<String>? list) {
    if (list == null || list.isEmpty) return "—";
    return list.join(" & ");
  }
}

class _RelationshipRow extends StatelessWidget {
  const _RelationshipRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.categoryKey,
    required this.sign,
    required this.titleSize,
    required this.valueSize,
    required this.lineThickness,
  });

  final IconData icon;
  final String title;
  final String value;
  final String categoryKey;
  final String sign;

  final double titleSize;
  final double valueSize;
  final double lineThickness;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final scale = (math.min(w, h) / 390.0).clamp(0.85, 1.25);

    final iconSize = (16.0 * scale).clamp(14.0, 20.0);
    final gapS = (8.0 * scale).clamp(6.0, 10.0);
    final gapM = (10.0 * scale).clamp(8.0, 12.0);

    final chevronSize = (20.0 * scale).clamp(18.0, 24.0);
    final chevronHit = (32.0 * scale).clamp(28.0, 36.0);

    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.white.withValues(alpha: 0.90)),
        SizedBox(width: gapS),

        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.90),
          ),
        ),

        SizedBox(width: gapM),

        // 👇 Everything except chevron lives inside this Expanded
        Expanded(
          child: Row(
            children: [
              // LINE
              Expanded(
                child: Container(
                  height: lineThickness,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

              SizedBox(width: gapM),

              // VALUE (right aligned inside Expanded area)
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),
            ],
          ),
        ),

        // 👇 Chevron OUTSIDE Expanded → now truly rightmost
        SizedBox(
          width: chevronHit,
          height: chevronHit,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                final detail = ZodiacRelationshipDetailRepository.getDetail(
                  sign,
                  categoryKey,
                );

                ZodiacStagePopup.show(
                  context,
                  title: detail.label,
                  body: detail.body,
                );
              },
              child: Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: chevronSize,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
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
              color: Colors.white.withValues(alpha: 0.10),
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
  const _InsetDivider({required this.inset, required this.thickness});

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
