import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_processing_analysis/config/routes/app_routes.dart';

void main() {
  test('AppRoutes defines all expected routes', () {
    expect(AppRoutes.splash, '/splash');
    expect(AppRoutes.home, '/home');
    expect(AppRoutes.processing, '/processing');
    expect(AppRoutes.textRecognition, '/text-recognition');
    expect(AppRoutes.liveTextRecognition, '/live-text-recognition');
    expect(AppRoutes.faceDetection, '/face-detection');
    expect(AppRoutes.historyDetail, '/history-detail');
  });
}
