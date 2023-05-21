import 'package:clean_beaches_app/report.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

final testData = [
  Report(
    id: '12dd',
    position: LatLng(45.435651, 10.993239),
    cleaned: false,
    date: DateTime(2023, 12, 10),
    details: 'Spiaggia della morte',
    dirtyImageExtension: 'png',
    cleanImageExtension: 'png',
  ),
  Report(
    id: '11dd',
    position: LatLng(89.435651, 10.993239),
    cleaned: true,
    date: DateTime(2023, 11, 10),
    details: 'Spiaggia della morte 2',
    dirtyImageExtension: 'png',
    cleanImageExtension: 'png',
  ),
  Report(
    id: '10dd',
    position: LatLng(40.435651, 50.993239),
    cleaned: false,
    date: DateTime(2023, 10, 10),
    details: 'Spiaggia della morte 3',
    dirtyImageExtension: 'png',
    cleanImageExtension: 'png',
  ),
];

void showSnackBar({
  required BuildContext context,
  required String text,
  IconData? icon,
  Color? backgroundColor,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor:
          backgroundColor ?? Theme.of(context).snackBarTheme.backgroundColor,
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color ?? Theme.of(context).snackBarTheme.actionTextColor,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ?? Theme.of(context).snackBarTheme.actionTextColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
