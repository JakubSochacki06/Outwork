import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as systempaths;
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';

class ImageInput extends StatelessWidget {
  File? _storedImage;

  @override
  Widget build(BuildContext context) {
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context);

    Future<void> _pickImage(ImageSource source) async {
      final ImagePicker _picker = ImagePicker();
      final imageFile = await _picker.pickImage(source: source, maxWidth: 600);
      if (imageFile == null) {
        return;
      }
      final croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path, aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (croppedImage == null) {
        return;
      }
      _storedImage = File(croppedImage!.path);
      final appDir = await systempaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      final savedImage = await File(imageFile.path).copy(
          '${appDir.path}/$fileName');
      journalEntryProvider.setSavedImage(savedImage);
      journalEntryProvider.setStoredImage(_storedImage!);
    }


    return Row(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: journalEntryProvider.journalEntry.storedImage != null
              ? Image.file(
            _storedImage!,
            fit: BoxFit.fill,
            width: double.infinity,
          )
              : Text('No image taken', textAlign: TextAlign.center,),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text('Take picture', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              ),
              TextButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.picture_as_pdf),
                label: Text('Choose from gallery', style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ],
    );
  }
}