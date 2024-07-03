import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wni/models/profile.dart';
import 'package:wni/services/profile_service.dart';

class ChangeProfileDialog extends StatefulWidget {
  final Profile profile;
  const ChangeProfileDialog({super.key, required this.profile});

  @override
  State<ChangeProfileDialog> createState() => _ChangeProfileDialogState();
}

class _ChangeProfileDialogState extends State<ChangeProfileDialog> {
  XFile? _imageFile;
  ImageSource? _source;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _source = source;
    });
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ganti Profile Picture'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Image terpilih '),
          ),
          Expanded(
            child: _imageFile != null && _source == ImageSource.gallery
                // Jika dijalankan dalam mobile, jangan lupa ganti
                // Image.network menjadi Image.file
                ? Image.network(
                    _imageFile!.path,
                    fit: BoxFit.cover,
                  )
                : _imageFile != null && _source == ImageSource.camera
                    ? Image.network(
                        _imageFile!.path,
                        fit: BoxFit.cover,
                      )
                    : Container(),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt),
              ),
              IconButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
              ),
              IconButton(
                onPressed: () {
                  _clear();
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            String? imageUrl;
            if (_imageFile != null) {
              imageUrl = await ProfileService.uploadImage(_imageFile!);
            } else {
              imageUrl = widget.profile.profileUrl;
            }
            ProfileService.updateProfilePicture(widget.profile, imageUrl)
                .whenComplete(() => Navigator.of(context).pop());
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
