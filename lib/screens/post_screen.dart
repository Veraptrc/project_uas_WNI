import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:wni/components/dark_input_field.dart';
import 'package:wni/services/post_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Image yang akan dipilih
  XFile? _imageFile;

  Future<void> _postToFirestore(String? imageUrl) async {
    String nama = _namaController.text.trim();
    String lokasi = _lokasiController.text.trim();
    String latitude = _latitudeController.text.trim();
    String longitude = _longitudeController.text.trim();
    String deskripsi = _deskripsiController.text.trim();

    if (nama.isEmpty ||
        lokasi.isEmpty ||
        latitude.isEmpty ||
        longitude.isEmpty ||
        deskripsi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua input harus diisi')),
      );
      return;
    } else {
      try {
        await FirebaseFirestore.instance.collection('wisata').add({
          'nama': nama,
          'lokasi': lokasi,
          'latitude': latitude,
          'longitude': longitude,
          'deskripsi': deskripsi,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': [],
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data telah ditambahkan')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data gagal ditambahkan')),
          );
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Wisata'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DarkInputField(
              controller: _namaController,
              labelText: 'Nama Tempat',
              obscureText: false,
            ),
            DarkInputField(
              controller: _lokasiController,
              labelText: 'Lokasi',
              obscureText: false,
            ),
            DarkInputField(
              controller: _latitudeController,
              labelText: 'Latitude',
              obscureText: false,
            ),
            DarkInputField(
              controller: _longitudeController,
              labelText: 'Longitude',
              obscureText: false,
            ),
            DarkInputField(
              controller: _deskripsiController,
              labelText: 'Deskripsi',
              obscureText: false,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: SizedBox(
                height: 250,
                child: _imageFile != null
                    ? Image.network(
                        _imageFile!.path,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: const Color.fromARGB(255, 48, 85, 77),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+',
                                style: TextStyle(fontSize: 24),
                              ),
                              Text('Upload Foto Tempat Wisata'),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 245, 250, 225),
              thickness: 1,
            ),
            //
            const SizedBox(height: 64.0),
            //
            ElevatedButton(
              onPressed: () async {
                String? imageUrl;
                if (_imageFile != null) {
                  imageUrl = await PostService.uploadImage(_imageFile!);
                } else {
                  imageUrl = '';
                }
                _postToFirestore(imageUrl);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 48, 85, 77),
                  ),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 144))),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 245, 250, 225),
                ),
              ),
            ),
            //
            const SizedBox(height: 16.0),
            //
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.brown,
                  ),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 148))),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 245, 250, 225),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
