import 'package:flutter/material.dart';

class WorkWithDate {
  static Future<DateTime?> pickDate(context, {firstDate, lastDate})async {
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return null;

    DateTime dateTimeOfInjury = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    return dateTimeOfInjury;
  }
}