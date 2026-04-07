String formatBirthdayShort(String fullDate) {
  try {
    final date = DateTime.parse(fullDate);

    const monthShort = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = monthShort[date.month - 1];
    final year = date.year.toString();

    return '$day $month $year';
  } catch (_) {
    return fullDate; // fallback if parsing fails
  }
}