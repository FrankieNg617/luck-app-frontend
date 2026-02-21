class ZodiacRelationshipRepository {
  static final Map<String, Map<String, List<String>>> _data = {
    "Aries": {
      "love": ["Leo"],
      "friendship": ["Leo"],
      "sex": ["Scorpio"],
      "work": ["Pisces"],
    },
    "Taurus": {
      "love": ["Virgo"],
      "friendship": ["Cancer"],
      "sex": ["Scorpio"],
      "work": ["Virgo"],
    },
    "Gemini": {
      "love": ["Libra"],
      "friendship": ["Aries"],
      "sex": ["Aquarius"],
      "work": ["Aries"],
    },
    "Cancer": {
      "love": ["Scorpio"],
      "friendship": ["Pisces"],
      "sex": ["Taurus"],
      "work": ["Taurus"],
    },
    "Leo": {
      "love": ["Aries"],
      "friendship": ["Aquarius"],
      "sex": ["Libra"],
      "work": ["Virgo"],
    },
    "Virgo": {
      "love": ["Taurus"],
      "friendship": ["Capricorn"],
      "sex": ["Aries"],
      "work": ["Libra"],
    },
    "Libra": {
      "love": ["Gemini"],
      "friendship": ["Aries"],
      "sex": ["Sagittarius"],
      "work": ["Aquarius"],
    },
    "Scorpio": {
      "love": ["Cancer"],
      "friendship": ["Taurus"],
      "sex": ["Pisces"],
      "work": ["Capricorn"],
    },
    "Sagittarius": {
      "love": ["Aquarius"],
      "friendship": ["Aries"],
      "sex": ["Leo"],
      "work": ["Taurus"],
    },
    "Capricorn": {
      "love": ["Pisces"],
      "friendship": ["Virgo"],
      "sex": ["Gemini"],
      "work": ["Leo"],
    },
    "Aquarius": {
      "love": ["Sagittarius"],
      "friendship": ["Aries"],
      "sex": ["Gemini"],
      "work": ["Sagittarius"],
    },
    "Pisces": {
      "love": ["Capricorn"],
      "friendship": ["Scorpio"],
      "sex": ["Libra"],
      "work": ["Scorpio"],
    },
  };

  static Map<String, List<String>> getRelationships(String sign) {
    return _data[sign] ?? {"love": [], "friendship": [], "sex": [], "work": []};
  }
}
