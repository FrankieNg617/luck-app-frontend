// data/zodiac_relationship_detail.dart

class ZodiacRelationshipDetail {
  const ZodiacRelationshipDetail({
    required this.label,
    required this.body,
  });

  final String label;
  final String body;
}

class ZodiacRelationshipDetailRepository {
  // Structure:
  // {
  //   "Aries": {
  //     "love": ZodiacRelationshipDetail(label: "...", body: "..."),
  //     "friendship": ...,
  //     "sex": ...,
  //     "work": ...,
  //   }
  // }

  static final Map<String, Map<String, ZodiacRelationshipDetail>> _data = {
    // ✅ TEST: apply to ALL zodiacs (until you paste real data)
    "_default": {
      "love": ZodiacRelationshipDetail(
        label: "Love",
        body: "Test detail content for Love.\n\n(Replace with real data later.)",
      ),
      "friendship": ZodiacRelationshipDetail(
        label: "Friendship",
        body:
            "Test detail content for Friendship.\n\n(Replace with real data later.)",
      ),
      "sex": ZodiacRelationshipDetail(
        label: "Sex",
        body: "Test detail content for Sex.\n\n(Replace with real data later.)",
      ),
      "work": ZodiacRelationshipDetail(
        label: "Work",
        body: "Test detail content for Work.\n\n(Replace with real data later.)",
      ),
    },
  };

  static ZodiacRelationshipDetail getDetail(
    String sign,
    String category, // "love" | "friendship" | "sex" | "work"
  ) {
    final signMap = _data[sign];
    final detail = signMap?[category] ?? _data["_default"]?[category];

    return detail ??
        const ZodiacRelationshipDetail(
          label: "Info",
          body: "No data available.",
        );
  }
}