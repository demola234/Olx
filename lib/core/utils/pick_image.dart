import 'package:image_picker/image_picker.dart';
import 'custom_toasts.dart';

Future pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file == null) {
    print(_file!.path);
  }

  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    Toasts.showErrorToast("No Image Selected");
  }
}
