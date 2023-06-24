import 'package:anitrak/src/bloc/search_bloc/search_bloc.dart';
import 'package:anitrak/src/pages/media_detail_page.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/ui_widgets/search_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _editingController = TextEditingController();
  Widget customSearchBar = const Text("Search");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = RepositoryProvider.of<MediaLibraryRepo>(context);
        return SearchBloc(repo)..add(MediaSearchEvent(search: null));
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: customSearchBar,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            child: ListTile(title: _getCustomSearchBar()),
            preferredSize: const Size.fromHeight(kToolbarHeight),
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = state as SearchData;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaDetailPage(
                            media: data.mediaList[index],
                          ),
                        ),
                      );
                    },
                    child: SearchListItem(
                      mediaModel: data.mediaList[index],
                    ),
                  );
                },
                itemCount: data.mediaList.length,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getCustomSearchBar() {
    return Builder(builder: (context) {
      return TextField(
        controller: _editingController,
        onChanged: (String text) {
          BlocProvider.of<SearchBloc>(context)
              .add(MediaSearchEvent(search: text));
        },
        decoration: InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              _editingController.clear();
            },
            icon: const Icon(
              Icons.close_sharp,
            ),
          ),
          prefixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ),
      );
    });
  }
}
