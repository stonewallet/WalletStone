import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionTimeOutListener extends StatefulWidget {
  final Widget child;
  final Duration initialDuration;
  final VoidCallback onTimeOut;

  const SessionTimeOutListener({
    Key? key,
    required this.child,
    required this.initialDuration,
    required this.onTimeOut,
  }) : super(key: key);

  @override
  State<SessionTimeOutListener> createState() => _SessionTimeOutListenerState();
}

class _SessionTimeOutListenerState extends State<SessionTimeOutListener> {
  Timer? _timer;
  Duration? _currentDuration;

  Future<void> _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOption = prefs.getString('selectedOption') ?? '10 minutes';
    log(savedOption);

    setState(() {
      _currentDuration = _parseDuration(savedOption);
    });
  }

  Duration _parseDuration(String option) {
    switch (option) {
      case '5 minutes':
        return const Duration(minutes: 5);
      case '15 minutes':
        return const Duration(minutes: 15);
      default:
        return const Duration(minutes: 10);
    }
  }

  void _startTimer() async {
    await _loadSelectedOption();

    log("Timer Reset");

    if (_timer != null) {
      log('inside timer');
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(_currentDuration ?? widget.initialDuration, () {
      log('inside timer2');
      log("Elapsed");
      log("the time is ${_currentDuration?.inMinutes ?? widget.initialDuration.inMinutes}");
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}
