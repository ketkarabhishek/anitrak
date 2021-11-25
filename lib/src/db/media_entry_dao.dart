import 'package:anitrak/src/models/media_entry.dart';
import 'package:floor/floor.dart';

@dao
abstract class MediaEntryDao {
  @Query('SELECT * FROM MediaEntry WHERE status = \'CURRENT\'')
  Stream<List<MediaEntry>> findAllMediaEntriesAsStream();

  @Query('SELECT * FROM MediaEntry WHERE status = CURRENT')
  Stream<List<MediaEntry>> findAllMediaEntries();

  // Insert
  @insert
  Future<void> insertMediaEntries(List<MediaEntry> mediaEntries);

  @insert
  Future<void> insertMediaEntry(MediaEntry mediaEntry);

  // Delete
  @Query('DELETE FROM MediaEntry')
  Future<void> deleteAllMediaEntries();

  @transaction
  Future<void> replaceMediaEntries(List<MediaEntry> mediaEntries) async {
    print(mediaEntries.length);
    await deleteAllMediaEntries();
    await insertMediaEntries(mediaEntries);
    print("Done");
    return;
  }
}
