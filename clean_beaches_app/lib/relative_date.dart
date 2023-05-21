extension RelativeDate on DateTime {
  String get relativeDateString {
    Duration duration = difference(DateTime.now());

    if (duration.inHours == 0) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inDays == 0) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }
}
