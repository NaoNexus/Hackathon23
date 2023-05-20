extension RelativeDate on DateTime {
  String? getRelativeDateString() {
    Duration duration = difference(DateTime.now());
  }
}
