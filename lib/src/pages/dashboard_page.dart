import 'package:anitrak/src/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:anitrak/src/models/library_item.dart';
import 'package:anitrak/src/pages/media_detail_page.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/ui_widgets/donut_chart.dart';
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
          if (state is DashboardEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Image.asset(
                          "images/home_cinema.png",
                        ),
                      ),
                    ),
                    Text(
                      'It\'s very empty here.',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                     Text(
                      'Search and add your anime or import from your tracking account.',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is DashboardData) {
            final data = state;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "Recents",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  _recentsList(data.recentsList),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      "Anime Stats",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  DonutChart(
                    currentCount: data.currentCount,
                    completedCount: data.completedCount,
                    plannedCount: data.plannedCount,
                    onHoldCount: data.onHoldCount,
                    droppedCount: data.droppedCount,
                    totalCount: data.totalEntries,
                  ),
                  _animeTime(data.totalTime),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _recentsList(List<LibraryItem> list) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final entry = list[index];
          final width = MediaQuery.of(context).size.width - 20;
          return SizedBox(
            width: width,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaDetailPage.withLibraryItem(
                      libraryItem: entry,
                    ),
                  ),
                );
              },
              child: RecentsListItem(
                libraryItem: entry,
                onTapNext: () {
                  final updated = entry.mediaEntry.copyWith(
                      progress: entry.mediaEntry.progress + 1, synced: false);
                  BlocProvider.of<DashboardBloc>(context)
                      .add(RecentsUpdated(updated));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _animeTime(int days) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                days.toString(),
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              Text(
                ' days spent watching Anime',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
        ),
      ),
    );
  }
}
