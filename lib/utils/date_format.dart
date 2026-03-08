String formatBirthdayShort(String fullDate) {
  final parts = fullDate.split(' ');
  if (parts.length != 3) return fullDate;

  final day = parts[0];
  final month = parts[1];
  final year = parts[2];

  const monthShort = {
    'January': 'Jan',
    'February': 'Feb',
    'March': 'Mar',
    'April': 'Apr',
    'May': 'May',
    'June': 'Jun',
    'July': 'Jul',
    'August': 'Aug',
    'September': 'Sep',
    'October': 'Oct',
    'November': 'Nov',
    'December': 'Dec',
  };

  final shortMonth = monthShort[month] ?? month;

  return '$day $shortMonth $year';
}