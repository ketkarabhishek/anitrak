import 'package:anitrak/src/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/ui_widgets/recents_list_item.dart';
import 'package:anitrak/src/ui_widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: const Text('Anitrak'),
            bottom: const SearchBar(),
          ),
          SliverToBoxAdapter(
            child: _getBody(),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    return BlocProvider<DashboardBloc>(
      create: (context) {
        final repo = RepositoryProvider.of<MediaLibraryRepo>(context);
        return DashboardBloc(repo)..add(DashboardInitialized());
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardData) {
            final data = state;
            return _recentsList(data.recentsStream);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _recentsList(Stream<List<LibraryItem>> recentsStream) {
    return StreamBuilder<List<LibraryItem>>(
      stream: recentsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text('Empty'),
          );
        }
        final list = snapshot.data!;
        return SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final entry = list[index];
              final width = MediaQuery.of(context).size.width - 20;
              return SizedBox(
                width: width,
                child: RecentsListItem(
                  libraryItem: entry,
                  onTapNext: () {
                    final updated = entry.mediaEntry
                        .copyWith(progress: entry.mediaEntry.progress + 1);
                    BlocProvider.of<DashboardBloc>(context)
                        .add(RecentsUpdated(updated));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
