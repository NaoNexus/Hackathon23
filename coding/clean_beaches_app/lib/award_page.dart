import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class AwardPage extends StatefulWidget {
  AwardPage(
      {super.key,
      required this.numberOfReportsDone,
      required this.numberOfBeachesCleaned});

  int numberOfReportsDone;
  int numberOfBeachesCleaned;

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  late int reporterLevel;
  late int cleanerLevel;
  double percentageLevelCleaned = 0;
  double percentageLevelReported = 0;

  @override
  void initState() {
    _calculatePercentageAndLevels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                const Flexible(
                  child: Text(
                    'Awards',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), //back arrow
              ],
            ),
            const SizedBox(height: 40),
            //show awards
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.zoom_in_outlined),
                        title: const Text('Reporter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle:
                            const Text('Make as many reports \n as you can'),
                        trailing: Text('Level $reporterLevel'),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 17.0,
                            animation: true,
                            animationDuration: 1400,
                            percent: percentageLevelReported,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.emoji_events_outlined,
                                  size: 40,
                                ),
                                Text('${percentageLevelReported * 100} %'),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.lightBlueAccent,
                          )),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cleaning_services_outlined),
                        title: const Text('Cleaner',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle:
                            const Text('Clean as many beaches \n as you can'),
                        trailing: Text('Level $cleanerLevel'),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 17.0,
                            animation: true,
                            animationDuration: 1400,
                            percent: percentageLevelCleaned,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.emoji_events_outlined,
                                  size: 40,
                                ),
                                Text('${percentageLevelCleaned * 100} %'),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.lightBlueAccent,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _calculatePercentageAndLevels() {
    if (widget.numberOfReportsDone < 2) {
      reporterLevel = 1;
    } else if (widget.numberOfReportsDone >= 2 &&
        widget.numberOfReportsDone < 5) {
      reporterLevel = 2;
    } else {
      reporterLevel = 3;
    }

    if (widget.numberOfBeachesCleaned < 2) {
      cleanerLevel = 1;
    } else if (widget.numberOfBeachesCleaned >= 2 &&
        widget.numberOfBeachesCleaned < 5) {
      cleanerLevel = 2;
    } else {
      cleanerLevel = 3;
    }
    switch (widget.numberOfReportsDone) {
      case 0:
        percentageLevelReported = 0;
        break;
      case 1:
        percentageLevelReported = 0.1;
        break;
      case 2:
        percentageLevelReported = 0.2;
        break;
      case 3:
        percentageLevelReported = 0.3;
        break;
      case 4:
        percentageLevelReported = 0.4;
        break;
      case 5:
        percentageLevelReported = 0.5;
        break;
      case 6:
        percentageLevelReported = 0.6;
        break;
      case 7:
        percentageLevelReported = 0.7;
        break;
      case 8:
        percentageLevelReported = 0.8;
        break;
      case 9:
        percentageLevelReported = 0.9;
        break;
      case 10:
        percentageLevelReported = 1;
        break;
    }
    switch (widget.numberOfBeachesCleaned) {
      case 0:
        percentageLevelCleaned = 0;
        break;
      case 1:
        percentageLevelCleaned = 0.1;
        break;
      case 2:
        percentageLevelCleaned = 0.2;
        break;
      case 3:
        percentageLevelCleaned = 0.3;
        break;
      case 4:
        percentageLevelCleaned = 0.4;
        break;
      case 5:
        percentageLevelCleaned = 0.5;
        break;
      case 6:
        percentageLevelCleaned = 0.6;
        break;
      case 7:
        percentageLevelCleaned = 0.7;
        break;
      case 8:
        percentageLevelCleaned = 0.8;
        break;
      case 9:
        percentageLevelCleaned = 0.9;
        break;
      case 10:
        percentageLevelCleaned = 1;
        break;
    }
  }
}
