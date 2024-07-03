import 'package:flutter/material.dart';
import 'package:wni/components/round_card.dart';
import 'package:wni/models/rencana.dart';
import 'package:wni/models/wisata.dart';
import 'package:wni/services/rencana_service.dart';

class RencanaScreen extends StatefulWidget {
  const RencanaScreen({super.key});

  @override
  State<RencanaScreen> createState() => _RencanaScreenState();
}

class _RencanaScreenState extends State<RencanaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Wisata'),
      ),
      body: FutureBuilder<List<Rencana>>(
        future: RencanaService.getRencanaList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Rencana found'));
              }
              List<Rencana> rencanaList = snapshot.data!;
              return ListView.builder(
                itemCount: rencanaList.length,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) {
                  Rencana rencana = rencanaList[index];
                  return FutureBuilder<Wisata?>(
                    future: RencanaService.getWisataById(rencana.wisataId),
                    builder: (context, wisataSnapshot) {
                      if (wisataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text(
                            rencana.waktuBerangkat.toString(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          subtitle: const Text('Loading...'),
                        );
                      } else if (wisataSnapshot.hasError) {
                        return ListTile(
                          title: Text(
                            rencana.waktuBerangkat.toString(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          subtitle: const Text('Error loading wisata'),
                        );
                      } else if (!wisataSnapshot.hasData) {
                        return ListTile(
                          title: Text(
                            rencana.waktuBerangkat.toString(),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          subtitle: const Text('No wisata found'),
                        );
                      } else {
                        Wisata wisata = wisataSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "${rencana.waktuBerangkat.year.toString()}-${rencana.waktuBerangkat.month.toString().padLeft(2, '0')}-${rencana.waktuBerangkat.day.toString().padLeft(2, '0')} ${rencana.waktuBerangkat.hour.toString().padLeft(2, '0')}-${rencana.waktuBerangkat.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Peringatan"),
                                              content: const Text(
                                                  "Yakin ingin mengahapus rencana?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    RencanaService
                                                            .deleteRencana(
                                                                rencana)
                                                        .whenComplete(() {
                                                      setState(() {
                                                        rencanaList
                                                            .remove(rencana);
                                                      });
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Ya"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  )
                                ],
                              ),
                            ),
                            RoundCard(
                              wisata: wisata,
                              withBottom: false,
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}
