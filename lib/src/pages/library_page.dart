import 'package:anitrak/src/bloc/lib_page_bloc/lib_page_bloc.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/pages/lib_item_edit_page.dart';
import 'package:anitrak/src/pages/media_detail_page.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/ui_widgets/lib_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        final repo = RepositoryProvider.of<MediaLibraryRepo>(context);
        return LibPageBloc(repo)..add(LibraryFetchedEvent());
      },
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) {
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
              },
              body: BlocBuilder<LibPageBloc, LibPageState>(
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

  Widget _libraryListView(Stream<List<LibraryItem>> stream) {
    return StreamBuilder<List<LibraryItem>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }

        if (snapshot.hasData) {
          final data = snapshot.requireData;
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Image.asset('images/no_data.png',),
                    ),
                  ),
                   Text(
                      'There\'s nothing here.',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => LibListItem(
              libraryItem: data[index],
              onTap: () async {
                Navigator.push<MediaEntry>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaDetailPage.withLibraryItem(
                      libraryItem: data[index],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
