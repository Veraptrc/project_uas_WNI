import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wni/components/detail_box.dart';

class AddRencanaScreen extends StatefulWidget {
  const AddRencanaScreen({super.key});

  @override
  State<AddRencanaScreen> createState() => _AddRencanaScreenState();
}

class _AddRencanaScreenState extends State<AddRencanaScreen> {
  DateTime? waktuBerangkat;

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DetailBox(
              section: "Waktu Berangkat",
              text: waktuBerangkat != null
                  ? DateFormat('EEEE, d MMM, yyyy').format(waktuBerangkat!)
                  : "Kosong",
              onPressed: () async {
                DateTime? waktuTerpilih =
                    await showDateTimePicker(context: context);
                setState(() {
                  waktuBerangkat = waktuTerpilih;
                });
              },
            ),
            TextButton(onPressed: () {}, child: const Text("SIMPAN"))
          ],
        ),
      ),
    );
  }
}
