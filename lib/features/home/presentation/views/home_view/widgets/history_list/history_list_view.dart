import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ضفنا الـ Get عشان الـ GetView
import 'package:open_filex/open_filex.dart';
import '../../../../../../../core/utils/utils/constants/enums/ProcessingType.dart';
import '../../../../../data/models/history_model.dart';
import '../../../../controllers/home_controller.dart';
import 'history_card.dart';

class HistoryListView extends GetView<HomeController> {
  final List<HistoryModel> items;

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
            onTap: () async {
              if (item.type == ProcessingType.document || item.type == ProcessingType.text) {
                await OpenFilex.open(item.imagePath);
              } else {
                log("Opening Text Result: ${item.result}");
              }
            },
          ),
        );
      },
    );
  }
}