import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:flutter/material.dart';

class RecentsListItem extends StatelessWidget {
  const RecentsListItem({Key? key, required this.libraryItem, this.onTapNext})
      : super(key: key);

  final LibraryItem libraryItem;
  final void Function()? onTapNext;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  libraryItem.media.poster,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        libraryItem.media.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${libraryItem.mediaEntry.progress}/${libraryItem.media.total == 0 ? "-" : libraryItem.media.total}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w300),
                        maxLines: 1,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: libraryItem.media.total > 0
                          ? libraryItem.mediaEntry.progress / libraryItem.media.total
                          : 0.0,
                      backgroundColor: Colors.grey[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton.icon(
                          onPressed: onTapNext,
                          icon: const Icon(Icons.plus_one),
                          label: const Text('Next')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
