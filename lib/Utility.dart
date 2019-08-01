import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CentralStation {
  static bool _updateNeeded;
  static final fontColor = Color.fromARGB(255, 59, 73, 73);
  static final borderColor = Color(0xffe1e1e1);

  static init() {
    if (_updateNeeded == null) _updateNeeded = true;
  }

  static bool get updateNeeded {
    init();
    return _updateNeeded;
  }

  static set updateNeeded(val) {
    _updateNeeded = val;
  }

  static String stringFromDateTime(DateTime dateTime) {
    var localDateTime = dateTime.toLocal();
    var now = DateTime.now().toLocal();
    var dateSting = "Изменено ";
    var diff = now.difference(localDateTime);

    if (now.day == localDateTime.day)
      dateSting += DateFormat("HH:mm").format(localDateTime);
    else if ((diff.inDays == 1) || (diff.inSeconds < 86400 && now.day != localDateTime.day))
      dateSting += "Вчера, в " + DateFormat("HH:mm").format(localDateTime);
    else if (now.year == localDateTime.year && diff.inDays > 1)
      dateSting += DateFormat("d MMM").format(localDateTime);
    else dateSting += DateFormat("d MMM y").format(localDateTime);

    return dateSting;
  }
}
