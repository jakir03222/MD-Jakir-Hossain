import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:biddabar_test_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await GetStorage.init();
  });

  testWidgets('App boots to Biddabari home', (tester) async {
    await tester.pumpWidget(const BiddabariApp());
    await tester.pump();

    expect(find.text('Biddabari Courses'), findsOneWidget);
  });
}
