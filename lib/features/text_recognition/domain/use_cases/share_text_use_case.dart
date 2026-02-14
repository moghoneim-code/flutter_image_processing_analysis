import 'package:share_plus/share_plus.dart';

class ShareTextUseCase {
  Future<void> execute(String text) async {
    await Share.share(text);
  }
}