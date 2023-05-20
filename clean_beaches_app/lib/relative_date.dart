extension RelativeDate on DateTime {
  String get relativeDateString {
    Duration duration = difference(DateTime.now());

    if (duration.inHours == 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return '${duration.inHours} hours ago';
    }
  }
}
