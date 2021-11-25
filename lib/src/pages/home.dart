import 'package:anitrak/src/bloc/app_bloc/app_bloc.dart';
import 'package:anitrak/src/bloc/home_bloc/home_bloc.dart';
import 'package:anitrak/src/db/database.dart';
import 'package:anitrak/src/db/dbhelper.dart';
import 'package:anitrak/src/db/media_entry_dao.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/ui_widgets/lib_list_item.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final db = RepositoryProvider.of<DataBase>(context);
        return HomeBloc(db)..add(HomeInitialized());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            BlocProvider.of<AppBloc>(context).add(ImportAnilistAppEvent());
          },
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.failure:
                return const Center(child: Text('failed to fetch media'));
              case HomeStatus.success:
                return StreamBuilder<List<MediaEntry>>(
                    stream: state.mediaListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(child: Text("Error"));
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("Empty"));
                      }

                      final mediaList = snapshot.requireData;
                      return ListView.builder(
                          itemCount: mediaList.length,
                          itemBuilder: (context, index) {
                            return LibListItem(
                              mediaEntry: mediaList[index],
                            );
                          });
                    });
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        // body: StreamBuilder<List<MediaEntry>>(
        //     stream: dao.findAllMediaEntriesAsStream(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError || !snapshot.hasData) {
        //         return const Center(child: Text("Error"));
        //       }
        //       // if (snapshot.data!.isEmpty) {
        //       //   return const Center(child: Text("Empty"));
        //       // }
        //       final mediaList = snapshot.requireData;
        //       return ListView.builder(
        //           itemCount: mediaList.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               leading: Image.network(mediaList[index].poster),
        //               title: Text(mediaList[index].title),
        //             );
        //           });
        //     }),
      ),
    );
  }
}
