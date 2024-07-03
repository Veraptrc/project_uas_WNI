import 'package:flutter/material.dart';
import 'package:wni/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          backgroundColor: const Color.fromARGB(255, 48, 85, 77),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 245, 250, 225),
            fontSize: 32.0,
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 245, 250, 225),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 250, 225),
        body: StreamBuilder(
          stream: NotificationService.getNotifikasiList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.data!.isNotEmpty) {
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: snapshot.data!.map((document) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              title: Text(document.judul),
                              subtitle: Text(document.pesan),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: Text('Notifikasi Kosong'),
                  );
                }
            }
          },
        ));
  }
}
