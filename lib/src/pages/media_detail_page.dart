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

class _MediaDetailPageState extends State<MediaDetailPage>
    with TickerProviderStateMixin<MediaDetailPage> {
  late AnimationController _colorAnimationController;
  late Animation _appBarColorTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      var target = scrollInfo.metrics.pixels /
          (MediaQuery.of(context).size.height * 0.10);
      _colorAnimationController.animateTo(target);
      return true;
    }
    return false;
  }

  List<MediaEntryStatus> getStatusList() {
    switch (widget.media.mediaStatus) {
      case MediaStatus.tba:
        return [MediaEntryStatus.planned];
      case MediaStatus.current:
        List<MediaEntryStatus> res =
            MediaEntryStatus.values.toList(growable: true);
        res.remove(MediaEntryStatus.completed);
        return res;
      case MediaStatus.finished:
        return MediaEntryStatus.values;
    }
  }

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appBarColorTween = ColorTween(
            begin: Colors.transparent,
            end: Theme.of(context).appBarTheme.backgroundColor)
        .animate(_colorAnimationController);
    return Scaffold(
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
        child: NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              SingleChildScrollView(
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
                                  widget.media.coverImage,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.15,
                            left: 16,
                            right: 16,
                            child: Align(
                              alignment: Alignment.center,
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.media.poster,
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                ),
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
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${widget.media.mediaFormat.displayTitle} | ${widget.media.mediaSeason.displayTitle}, ${widget.media.year}',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${widget.media.mediaStatus.displayTitle} | ${widget.media.duration} mins | ${widget.media.total > 0 ? widget.media.total : " -"} eps',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BlocBuilder<MediaPageCubit, MediaPageCubitState>(
                      builder: (context, state) {
                        if (state is MediaPageInitial) {
                          return ElevatedButton.icon(
                              label: const Text('Add to Library'),
                              onPressed: () async {
                                final status =
                                    await showDialog<MediaEntryStatus>(
                                        context: context,
                                        builder: (context) =>
                                            _getAddDialog(context));
                                if (status == null) return;
                                final cubit =
                                    BlocProvider.of<MediaPageCubit>(context);
                                final entry = MediaEntry.createNewEntry(
                                  mediaId: widget.media.id,
                                  mstatus: status.index,
                                );
                                final item = LibraryItem(
                                    media: widget.media, mediaEntry: entry);
                                cubit.insertLibraryEntry(item);
                              },
                              icon: const Icon(Icons.add));
                        }

                        final data = state as MediaPageWithEntry;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _infoCard(
                                        title: 'Progress',
                                        value:
                                            data.mediaEntry.progress.toString(),
                                      ),
                                      _infoCard(
                                        title: 'Rating',
                                        value:
                                            '${data.mediaEntry.score == 0 ? "-" : data.mediaEntry.score}/10',
                                      ),
                                      _infoCard(
                                        title: 'Status',
                                        value: data.mediaEntry.entryStatus
                                            .displayTitle,
                                      ),
                                    ],
                                  ),
                                  FilledButton.icon(
                                    label: const Text("Edit"),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => LibItemEditPage(
                                            libraryItem: LibraryItem(
                                                media: widget.media,
                                                mediaEntry: data.mediaEntry),
                                          ),
                                        ),
                                      );
                                      if (result == null) return;
                                      if (result is MediaEntry) {
                                        BlocProvider.of<MediaPageCubit>(context)
                                            .updateMediaEntry(result);
                                        return;
                                      }
                                      BlocProvider.of<MediaPageCubit>(context)
                                          .deleteMediaEntry(LibraryItem(
                                              media: widget.media,
                                              mediaEntry: widget.mediaEntry!));
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Builder(
                        builder: (context) {
                          return Text.rich(
                            HTML.toTextSpan(context, widget.media.description,
                                defaultTextStyle:
                                    Theme.of(context).textTheme.bodyLarge),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                children: [
                  AnimatedBuilder(
                    animation: _colorAnimationController,
                    builder: (context, child) => AppBar(
                      backgroundColor: _appBarColorTween.value,
                      elevation: 0,
                      iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
    );
  }

  Widget _getAddDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Select Status'),
      children: getStatusList()
          .map(
            (e) => SimpleDialogOption(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  e.displayTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              onPressed: () => Navigator.pop(context, e),
            ),
          )
          .toList(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
