import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();
  XFile? _file = await _imagepicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}
