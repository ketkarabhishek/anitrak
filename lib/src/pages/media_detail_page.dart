import 'package:anitrak/src/cubits/media_page_cubit/media_page_cubit.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/pages/lib_item_edit_page.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_html_css/simple_html_css.dart';

class MediaDetailPage extends StatefulWidget {
  const MediaDetailPage({Key? key, required this.media, this.mediaEntry})
      : super(key: key);

  MediaDetailPage.withLibraryItem({Key? key, required LibraryItem libraryItem})
      : media = libraryItem.media,
        mediaEntry = libraryItem.mediaEntry,
        super(key: key);

  final MediaModel media;
  final MediaEntry? mediaEntry;

  @override
  _MediaDetailPageState createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.media.title),
        elevation: 0,
      ),
      body: BlocProvider(
        lazy: false,
        create: (context) {
          final repo = RepositoryProvider.of<MediaLibraryRepo>(context);
          final cubit = MediaPageCubit(repo);
          if (widget.mediaEntry == null) {
            cubit.getMediaEntry(widget.media.alMediaId);
          } else {
            cubit.setMediaEntry(widget.mediaEntry!);
          }
          return cubit;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.46,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  fit: StackFit.loose,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.media.poster,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: 16,
                      right: 16,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.media.poster,
                            height: MediaQuery.of(context).size.height * 0.30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.32,
                      left: 16,
                      right: 16,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: BlocBuilder<MediaPageCubit, MediaPageCubitState>(
                          builder: (context, state) {
                            if (state is MediaPageInitial) {
                              return ElevatedButton.icon(
                                  label: const Text('Add to Library'),
                                  onPressed: () {
                                    final cubit =
                                        BlocProvider.of<MediaPageCubit>(
                                            context);
                                    final entry = MediaEntry.createNewEntry(
                                      mediaId: widget.media.id,
                                    );
                                    final item = LibraryItem(
                                        media: widget.media, mediaEntry: entry);
                                    cubit.insertLibraryEntry(item);
                                  },
                                  icon: const Icon(Icons.add));
                            }

                            final data = state as MediaPageWithEntry;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${data.mediaEntry.score == 0 ? "-" : data.mediaEntry.score} / 10 \u2b50',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300),
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton.icon(
                                    label: Text(data.mediaEntry.status),
                                    onPressed: () async {
                                      final result =
                                          await Navigator.push<MediaEntry>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LibItemEditPage(
                                            libraryItem: LibraryItem(
                                                media: widget.media,
                                                mediaEntry: data.mediaEntry),
                                          ),
                                        ),
                                      );
                                      if (result == null) return;

                                      BlocProvider.of<MediaPageCubit>(context)
                                          .updateMediaEntry(result);
                                    },
                                    icon: const Icon(Icons.edit_sharp),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: Text(
                  widget.media.title,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${widget.media.duration} minutes',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      '${widget.media.total} episodes',
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return Text.rich(
                      HTML.toTextSpan(context, widget.media.description,
                          defaultTextStyle:
                              Theme.of(context).textTheme.bodyText1),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
