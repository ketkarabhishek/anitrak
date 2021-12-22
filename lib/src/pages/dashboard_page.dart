import 'package:anitrak/src/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:anitrak/src/ui_widgets/recents_list_item.dart';
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
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: BlocProvider<DashboardBloc>(
        create: (context) {
          final repo = RepositoryProvider.of<MediaEntriesRepo>(context);
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
      ),
    );
  }

  Widget _recentsList(Stream<List<MediaEntry>> recentsStream) {
    return StreamBuilder<List<MediaEntry>>(
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
            itemCount: 10,
            itemBuilder: (context, index) {
              final entry = list[index];
              final width = MediaQuery.of(context).size.width - 20;
              return SizedBox(
                width: width,
                child: RecentsListItem(
                  mediaEntry: entry,
                  onTapNext: () {
                    final updated =
                        entry.copyWith(progress: entry.progress + 1);
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
