import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/history_refresh_service.dart';
import '../../../../core/services/image_picker/image_picker_service.dart';
import '../../data/models/history_model.dart';
import '../../domain/use_cases/delete_history_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';

/// Controller managing the home screen state and user interactions.
///
/// [HomeController] loads processing history from the database,
/// handles history deletion, and manages the image picking flow
/// that initiates new processing sessions.
///
/// Dependencies:
/// - [getHistoryUseCase]: Retrieves all [HistoryModel] records.
/// - [deleteHistoryUseCase]: Deletes a specific history record by ID.
class HomeController extends GetxController {
  /// Use case for fetching history records.
  final GetHistoryUseCase getHistoryUseCase;

  /// Use case for deleting a history record.
  final DeleteHistoryUseCase deleteHistoryUseCase;

  /// Service for picking and cropping images.
  final ImagePickerService _imagePickerService = ImagePickerService();

  /// Creates a [HomeController] with the required use cases.
  HomeController({
    required this.getHistoryUseCase,
    required this.deleteHistoryUseCase,
  });

  /// Reactive list of history records displayed in the UI.
  var historyList = <HistoryModel>[].obs;

  /// Whether the history list is currently being loaded.
  var isLoading = true.obs;

  /// Holds the current failure state, or `null` if no error occurred.
  var failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    final refreshService = Get.find<HistoryRefreshService>();
    ever(refreshService.refreshCount, (_) => loadHistory());
  }

  /// Loads all history records from the database.
  ///
  /// Updates [isLoading], [historyList], and [failure] reactively
  /// so the UI can respond to each state transition.
  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      failure.value = null;

      historyList.value = await getHistoryUseCase.call();
    } catch (e) {
      failure.value = e is Failure ? e : DatabaseFailure('Unexpected error loading history: $e');
      ErrorHandler.handle(e, fallbackMessage: 'Unexpected error loading history.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes the history item with the given [id] and removes it from the list.
  void deleteHistoryItem(int id) async {
    final success = await ErrorHandler.guardVoid(
      () => deleteHistoryUseCase.execute(id),
      fallbackMessage: 'Failed to delete item.',
    );
    if (success) {
      historyList.removeWhere((item) => item.id == id);
    }
  }

  /// Opens the image picker for the given [source] and navigates to processing.
  ///
  /// If an image is successfully selected, the current bottom sheet is
  /// dismissed and the user is navigated to the [ProcessingScreen]
  /// with the selected image as an argument.
  void pickImage(ImageSource source) async {
    await ErrorHandler.guardVoid(
      () async {
        final File? image = await _imagePickerService.pickImage(source);
        if (image != null) {
          Get.back();
          Get.toNamed(AppRoutes.processing, arguments: image);
        }
      },
      fallbackMessage: 'Failed to pick image.',
    );
  }
}