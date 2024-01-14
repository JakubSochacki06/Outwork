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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
      journalEntryProvider.journalEntry.hasPhoto = true;
    }


    return Row(
      children: [
        Container(
          width: width*0.3,
          height: height*0.1,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: journalEntryProvider.journalEntry.storedImage != null
              ? Image.file(
            journalEntryProvider.journalEntry.storedImage!,
            fit: BoxFit.fill,
            width: double.infinity,
          )
              : Text('No image taken', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.labelLarge,),
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
                icon: Icon(Icons.camera_alt),
                label: Text('Take picture', style: Theme.of(context).primaryTextTheme.labelLarge, textAlign: TextAlign.center,),
              ),
              TextButton.icon(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.photo),
                label: Text('Choose from gallery', style: Theme.of(context).primaryTextTheme.labelLarge, textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ],
    );
  }
}