import 'dart:async';

import 'package:cron/cron.dart';

final Cron _cron = Cron();

class CronJob {
  CronJob({
    required this.name,
    required this.time,
    required this.task,
  });

  String name;
  String time;
  Future<void> Function() task;

  ScheduledTask start() => _cron.schedule(Schedule.parse(time), task);
}
