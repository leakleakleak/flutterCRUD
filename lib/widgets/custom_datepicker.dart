import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    this.hasInitialDate,
  });

  final DateTime? hasInitialDate;
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? initialDate;

  @override
  void initState() {
    initialDate = widget.hasInitialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      initialValue: initialDate,
      mode: DateTimeFieldPickerMode.date,
      dateFormat: DateFormat.yMd(),
      validator: (value) {
        if (value == null) {
          return 'Please select a date';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Release Date',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
      ),
      onDateSelected: (DateTime value) {
        setState(() {
          initialDate = value;
        });
      },
    );
  }
}
