import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/services/image_picker/image_picker_service.dart';
import '../../data/models/history_model.dart';
import '../../domain/use_cases/delete_history_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';

class HomeController extends GetxController {
  final GetHistoryUseCase getHistoryUseCase;
  final DeleteHistoryUseCase deleteHistoryUseCase;
  final ImagePickerService _imagePickerService = ImagePickerService();

  HomeController({
    required this.getHistoryUseCase,
    required this.deleteHistoryUseCase,
  });

  var historyList = <HistoryModel>[].obs;
  var isLoading = true.obs;
  var failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      failure.value = null;

      // بننادي الـ Use Case
      historyList.value = await getHistoryUseCase.call();

    } on DatabaseFailure catch (e) {
      failure.value = e;
      SnackBarHelper.showErrorMessage(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteHistoryItem(int id) async {
    try {
      await deleteHistoryUseCase.execute(id);
      historyList.removeWhere((item) => item.id == id);
    } catch (e) {
      SnackBarHelper.showErrorMessage("Failed to delete item.");
    }
  }

  void pickImage(ImageSource source) async {
    final File? image = await _imagePickerService.pickImage(source);
    if (image != null) {
      Get.back();

      Get.toNamed(AppRoutes.processing, arguments: image);
    }
  }
}