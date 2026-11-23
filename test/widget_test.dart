import 'package:flutter_test/flutter_test.dart';
import 'package:personaltasklogger/task_tracker/task_tracker_app.dart';

void main() {
  testWidgets('TaskTracker app load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskTrackerApp());
  });
}
