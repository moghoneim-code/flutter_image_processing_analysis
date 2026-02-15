import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/features/home/presentation/views/home_view/widgets/history_list/history_list_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/models/ui_models/error_params.dart';
import '../../../../../../core/shared/widgets/error/app_error_widget.dart';
import '../../../../../../core/shared/widgets/text_fields/search_text_field.dart';
import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../../../core/utils/widgets/custom_bottom_sheets.dart';
import '../../../controllers/home_controller.dart';
import '../widgets/history_list/history_shimmer_loading.dart';
import '../widgets/home_header.dart';
import '../widgets/history_list/empty_history_view.dart';

/// The main home screen of the application.
///
/// [HomeScreen] displays the app header and a reactive list of
/// processing history records. It shows loading shimmer, error state,
/// empty state, or the history list based on the [HomeController] state.
///
/// A floating action button opens the image capture method selection
/// bottom sheet via [CustomBottomSheets.showImagePicker].
class HomeScreen extends GetView<HomeController> {
  /// Creates a [HomeScreen] instance.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchTextField(
                hint: 'Search history...',
                onChanged: (value) => controller.searchQuery.value = value,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const HistoryShimmerLoading();
                }
                if (!controller.failure.value.isNull) {
                  return AppErrorWidget(
                    params: ErrorParams(
                      message: controller.failure.value!.message,
                      onRetry: () => controller.loadHistory(),
                    ),
                  );
                }
                if (controller.historyList.isEmpty) {
                  return const EmptyHistoryView();
                }
                final filtered = controller.filteredHistoryList;
                if (filtered.isEmpty) {
                  return const EmptyHistoryView();
                }
                return HistoryListView(
                  items: filtered,
                  searchQuery: controller.searchQuery.value,
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.burrowingOwl,
        onPressed: () {
          CustomBottomSheets.showImagePicker(
            onCameraTap: () => controller.pickImage(ImageSource.camera),
            onGalleryTap: () => controller.pickImage(ImageSource.gallery),
          );
        },
        child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
      ),
    );
  }
}