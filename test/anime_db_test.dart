// Import the test package and Counter class
import 'package:anitrak/src/services/anime_offline_db.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Download anime mapping db', () async {
    final adb = await AnimeOffileDB.downloadDbFile();
    // print(adb);
    expect(adb, isNot(null));
  });
}
