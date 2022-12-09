import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

class _CalendarState extends State<Calendar> {
  var currentDate =
      DateFormat('EEE, MMM yyyy').format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          String formattedDate = DateFormat('EEE, MMM yyyy').format(
              pickedDate); // format date in required form here we use EEE, MMM yyyy

          setState(() {
            currentDate = formattedDate;
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currentDate,
              style: const TextStyle(
                  letterSpacing: 5.0, fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 10.0,
          ),
          const Icon(Icons.arrow_downward_rounded)
        ],
      ),
    );
  }
}
