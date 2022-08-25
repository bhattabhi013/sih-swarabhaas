import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';

class CallHistoryProvider extends ChangeNotifier {
  late final _callLogEntries;

  _getResult() {
    notifyListeners();
    return _callLogEntries;
  }

  _dialScreen() async {
    final Iterable<CallLogEntry> result = await CallLog.query();
    _callLogEntries = result;
    notifyListeners();
  }
}
