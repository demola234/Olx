import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../../../core/utils/config.dart';

// ignore: must_be_immutable
class OTPTimerWidget extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  OTPTimerWidget({required this.reset});
  Function(DateTime) reset;
  @override
  State<OTPTimerWidget> createState() => _OTPTimerWidgetState();
}

class _OTPTimerWidgetState extends State<OTPTimerWidget> {
  late DateTime alert;

  @override
  void initState() {
    alert = DateTime.now().add(const Duration(seconds: 90));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.scheduled([alert], builder: (context) {
      var now = DateTime.now();
      var reached = now.compareTo(alert) >= 0;

      return !reached
          ? TimerBuilder.periodic(const Duration(seconds: 1),
              alignment: Duration.zero, builder: (context) {
              var now = DateTime.now();
              var remaining = alert.difference(now);
              return Row(
                children: [
                  const Spacer(),
                  Text(
                    'Resend OTP in ${formatDuration(remaining)}'
                    " "
                    '${remaining >= const Duration(seconds: 60) ? "Mins" : "Secs"}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            })
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  widget.reset(alert);
                  alert = DateTime.now().add(const Duration(minutes: 2));
                },
                child: Row(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.timer,
                      size: 15,
                    ),
                    const XMargin(5),
                    Text('Resend OTP',
                        style: Config.b3(context).copyWith(
                          fontWeight: FontWeight.normal,
                        )),
                  ],
                ),
              ),
            );
    });
  }

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    // We want to round up the remaining time to the nearest second
    d += const Duration(microseconds: 999999);
    return " in ${f(d.inMinutes % 60)}:${f(d.inSeconds % 60)}";
  }
}
