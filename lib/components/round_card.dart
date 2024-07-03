import 'package:flutter/material.dart';
import 'package:wni/models/rencana.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/screens/detail_screen.dart';
import 'package:wni/services/profile_service.dart';
import 'package:wni/services/rencana_service.dart';

class RoundCard extends StatelessWidget {
  final Wisata wisata;
  final bool withBottom;
  const RoundCard({super.key, required this.wisata, required this.withBottom});

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
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(
            color: const Color.fromARGB(255, 48, 85, 77),
          )),
      child: Column(
        children: [
          wisata.imageUrl != null && Uri.parse(wisata.imageUrl!).isAbsolute
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Image.network(
                    wisata.imageUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                )
              : Container(),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    wisata: wisata,
                  ),
                ),
              );
            },
            title: Text(
              wisata.nama,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              wisata.lokasi.length > 62
                  ? '${wisata.lokasi.substring(0, 62)}...'
                  : wisata.lokasi,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          if (withBottom)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tambahkan ke rencana",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  IconButton(
                      onPressed: () async {
                        DateTime? waktuBerangkat =
                            await showDateTimePicker(context: context);
                        if (waktuBerangkat != null) {
                          Rencana rencana = Rencana(
                            wisataId: wisata.id!,
                            waktuBerangkat: waktuBerangkat,
                            userId: ProfileService.currentUser!.uid,
                          );

                          await RencanaService.addRencana(rencana);
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ))
                ],
              ),
            )
        ],
      ),
    );
  }
}
