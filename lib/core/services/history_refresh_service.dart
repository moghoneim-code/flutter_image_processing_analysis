import 'package:get/get.dart';

/// Global service that notifies listeners when the history list needs refreshing.
///
/// [HistoryRefreshService] is registered as a permanent GetX service
/// in [main]. Other controllers observe [refreshCount] to reactively
/// reload history data whenever [notify] is called after a write operation.
class HistoryRefreshService extends GetxService {
  /// Reactive counter that increments each time a refresh is requested.
  ///
  /// Controllers should use `ever(refreshCount, ...)` to listen for changes.
  final refreshCount = 0.obs;

  /// Triggers a history refresh by incrementing [refreshCount].
  ///
  /// Call this after any operation that modifies history records
  /// (insert, delete) so that all listening controllers reload their data.
  void notify() => refreshCount.value++;
}