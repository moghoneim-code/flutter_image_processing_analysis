import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/services/image_picker/image_picker_service.dart';
import '../../domain/use_cases/copy_to_clipboard_use_case.dart';
import '../../domain/use_cases/export_document_use_case.dart';
import '../../domain/use_cases/recognize_text_use_case.dart';
import '../../domain/use_cases/share_text_use_case.dart';

class TextRecognitionController extends GetxController {
  // 1. الـ Use Cases المحقونة من خلال الـ Binding (Constructor Injection)
  final RecognizeTextUseCase recognizeTextUseCase;
  final CopyToClipboardUseCase copyUseCase;
  final ShareTextUseCase shareUseCase;
  final ExportDocumentUseCase exportUseCase;

  // 2. الخدمات (Services)
  final ImagePickerService _imagePickerService = ImagePickerService();

  // 3. المتغيرات المراقبة (Observables)
  final Rxn<File> selectedImage = Rxn<File>();
  final RxString recognizedText = "Scanning...".obs;
  final RxBool isProcessing = false.obs;

  TextRecognitionController({
    required this.recognizeTextUseCase,
    required this.copyUseCase,
    required this.shareUseCase,
    required this.exportUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    // استلام الصورة من الـ Arguments وتشغيل المعالجة فوراً
    if (Get.arguments is File) {
      selectedImage.value = Get.arguments;
      processImage();
    } else {
      // حماية لو الشاشة فتحت غلط
      Get.back();
    }
  }

  // ميثود استخراج النص (OCR)
  Future<void> processImage() async {
    if (selectedImage.value == null) return;

    try {
      isProcessing.value = true;
      recognizedText.value = "Processing image...";

      // نداء الـ Use Case الخاص بالـ OCR
      final resultModel = await recognizeTextUseCase.execute(selectedImage.value!);

      // الحل الصحيح للـ Error: استخراج الـ String من الـ HistoryModel
      recognizedText.value = resultModel.result;

    } catch (e) {
      recognizedText.value = "Failed to extract text";
      SnackBarHelper.showErrorMessage("OCR Processing failed");
    } finally {
      isProcessing.value = false;
    }
  }

  // ميثود اختيار صورة جديدة من داخل الشاشة
  Future<void> pickNewImage(ImageSource source) async {
    final File? image = await _imagePickerService.pickImage(source);
    if (image != null) {
      selectedImage.value = image;
      processImage();
    }
  }

  // ميثود إنشاء الـ PDF والحفظ في الـ SQLite
  Future<void> generatePDF() async {
    if (selectedImage.value == null || recognizedText.value.isEmpty) return;

    try {
      isProcessing.value = true;
      await exportUseCase.execute(selectedImage.value!, recognizedText.value);

      SnackBarHelper.showSuccessMessage("PDF generated and saved to history!");
    } catch (e) {
      SnackBarHelper.showErrorMessage("Failed to generate PDF");
    } finally {
      isProcessing.value = false;
    }
  }

  // دوال الـ Clipboard والـ Share
  void copyToClipboard() {
    if (recognizedText.value.isNotEmpty) {
      copyUseCase.execute(recognizedText.value);
      SnackBarHelper.showInfoMessage("Copied to clipboard");
    }
  }

  void shareText() {
    if (recognizedText.value.isNotEmpty) {
      shareUseCase.execute(recognizedText.value);
    }
  }
}