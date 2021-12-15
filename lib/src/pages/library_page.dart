import 'package:anitrak/src/bloc/lib_page_bloc/lib_page_bloc.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/pages/lib_item_edit_page.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:anitrak/src/ui_widgets/lib_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = RepositoryProvider.of<MediaEntriesRepo>(context);
        return LibPageBloc(repo)..add(LibraryFetchedEvent());
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          floatingActionButton: BlocBuilder<LibPageBloc, LibPageState>(
            builder: (context, _) {
              return FloatingActionButton(
                child: const Icon(Icons.download_sharp),
                onPressed: () async {
                  BlocProvider.of<LibPageBloc>(context)
                      .add(LibraryImportedEvent());
                },
              );
            },
          ),
          body: NestedScrollView(headerSliverBuilder: (context, _) {
            return <Widget>[
              SliverAppBar(
                title: const Text('Library'),
                pinned: true,
                floating: true,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  tabs: const [
                    Tab(child: Text('Watching')),
                    Tab(child: Text('Completed')),
                    Tab(child: Text('Planned')),
                    Tab(child: Text('On Hold')),
                    Tab(child: Text('Dropped')),
                  ],
                ),
              ),
            ];
          }, body: BlocBuilder<LibPageBloc, LibPageState>(
            builder: (context, state) {
              if (state is LibPageLoading) {
                return const CircularProgressIndicator();
              }
              final libData = state as LibPageData;
              return TabBarView(
                children: [
                  _libraryListView(libData.currentEntriesStream),
                  _libraryListView(libData.completedEntriesStream),
                  _libraryListView(libData.plannedEntriesStream),
                  _libraryListView(libData.onholdEntriesStream),
                  _libraryListView(libData.droppedEntriesStream),
                ],
              );
            },
          )),
        ),
      ),
    );
  }

  Widget _libraryListView(Stream<List<MediaEntry>> stream) {
    return StreamBuilder<List<MediaEntry>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        if (snapshot.hasData) {
          final data = snapshot.requireData;
          if (data.isEmpty) {
            return const Center(child: Text("Empty"));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => LibListItem(
              mediaEntry: data[index],
              onTap: () async {
                final result = await Navigator.push<MediaEntry>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LibItemEditPage(
                      mediaEntry: data[index],
                    ),
                  ),
                );
                BlocProvider.of<LibPageBloc>(context)
                      .add(LibraryEntryUpdated(result!));
              },
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
