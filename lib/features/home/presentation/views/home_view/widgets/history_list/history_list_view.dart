import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/routes/app_routes.dart';
import '../../../../../../../core/utils/constants/enums/processing_type.dart';
import '../../../../../data/models/history_model.dart';
import '../../../../controllers/home_controller.dart';
import 'history_card.dart';

/// Scrollable list view displaying processing history records.
///
/// [HistoryListView] renders a [ListView] of [HistoryCard] widgets,
/// each representing a [HistoryModel] record. Items support swipe-to-delete
/// via [Dismissible] and tap-to-open via [OpenFilex].
///
/// Required data:
/// - [items]: The list of [HistoryModel] records to display.
class HistoryListView extends GetView<HomeController> {
  /// The list of history records to render.
  final List<HistoryModel> items;

  /// Creates a [HistoryListView] with the given [items].
  const HistoryListView({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        IconData getIcon() {
          switch (item.type) {
            case ProcessingType.document:
              return Icons.picture_as_pdf_rounded;
            case ProcessingType.face:
              return Icons.face_rounded;
            default:
              return Icons.image;
          }
        }

        return Dismissible(
          key: Key(item.id?.toString() ?? index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (item.id != null) {
              controller.deleteHistoryItem(item.id!);
            }
          },
          child: HistoryCard(
            title: item.type == ProcessingType.document ? "PDF Document" : item.result,
            subTitle: item.dateTime,
            icon: getIcon(),
            isPdf: item.type == ProcessingType.document,
            imagePath: item.imagePath,
            onTap: () {
              Get.toNamed(AppRoutes.historyDetail, arguments: item);
            },
          ),
        );
      },
    );
  }
}