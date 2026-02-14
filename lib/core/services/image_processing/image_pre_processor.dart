import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImagePreProcessor {
  Future<File> enhanceForScanning(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return imageFile;

    image = img.grayscale(image);
    image = img.adjustColor(image, contrast: 1.1);

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/pre_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await File(path).writeAsBytes(img.encodeJpg(image));
  }
}