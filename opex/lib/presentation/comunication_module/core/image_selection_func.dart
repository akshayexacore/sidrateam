import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../../core/utils/variables.dart';

Future<Uint8List> imageFileSelection({List<String>?allowedExtensions}) async {
  Uint8List? bytes;


  final pickedFile = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions:allowedExtensions?? ['jpg' ],
      withData: true);
  print(pickedFile?.files.first.name);
  // print(pickedFile?.files.first.mimeType);

  Variable.imageName=pickedFile?.files.first.name??"";




  if (pickedFile != null) {
    bytes = pickedFile.files.first.bytes;

  }
  print(bytes);
  return  bytes??Uint8List(0);


}