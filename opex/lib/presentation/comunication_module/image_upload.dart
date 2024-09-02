Future<void> uploadImageFIle() async {
  // final input = FileUploadInputElement()..accept = 'image/*';
  // input.click();

  // // Wait for the user to select a file
  // await input.onChange.first;

  // final file = input.files!.first;

  // final formData = FormData();
  // formData.appendBlob('image', file);

  // // Adding additional fields
  // // formData.set('user', 'john_doe');
  // // formData.set('description', 'This is a description.');

  // final request = HttpRequest();
  // request.open('POST', CommunicationUrls.uploadImageUrl);
  // request.send(formData);

  // // Handle the response
  // request.onLoad.listen((event) {
  //   print('Image uploaded successfully');
  // });
}

//
// class CustomTextSelectionControls extends MaterialTextSelectionControls {
//   @override
//   TextSelectionToolbar buildToolbar(BuildContext context, Rect globalEditableRegion, Offset position, TextSelectionDelegate delegate) {
//     // Customize the toolbar appearance
//     return super.buildToolbar(context, globalEditableRegion, position, delegate).copyWith(
//       color: Colors.red, // Change toolbar color to red
//     );
//   }
//
//   @override
//   Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight) {
//     // Customize the selection handles appearance
//     return super.buildHandle(context, type, textLineHeight);
//   }
// }

// Uint8List compressBytes(Uint8List bytes) {
//   // Convert Uint8List to JavaScript Uint8Array
//   var data = js.JsObject.jsify(bytes);
//
//   // Load zlib.js library
//   js.context.callMethod('eval', ["var Zlib = require('zlib')"]);
//
//   // Create a Uint8Array from the byte data
//   var uint8Array = js.JsObject(
//       js.context['Uint8Array'], [js.JsObject.jsify(bytes.buffer.asUint8List())]);
//
//   // Call zlib's deflate function
//   var compressedData =
//   js.context.callMethod('Zlib.deflate', [uint8Array]);
//
//   // Convert compressed data back to Uint8List
//   return Uint8List.fromList(List<int>.from(compressedData));
// }



