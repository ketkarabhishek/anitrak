import 'dart:async';

import 'package:anitrak/src/ui_widgets/creation_aware_list_item.dart';
import 'package:flutter/material.dart';

enum ListType { list, grid }

class InfiniteGridList<T> extends StatelessWidget {
  final Future<void> Function()? fetchData;
  final void Function()? refresh;
  final bool? hasMore;
  final bool? loading;
  final bool? nextLoading;
  final bool? error;
  final String? errorMessage;
  final Widget Function(T item)? itemBuilder;
  final Widget? header;
  final Stream<List<T>>? dataStream;
  final Function(BuildContext context, int index)? onItemTap;
  final ListType listType;
  final bool showSliverAppBar;
  final String? title;
  final String? description;

  const InfiniteGridList({
    Key? key,
    this.fetchData,
    this.refresh,
    this.loading,
    this.hasMore,
    this.nextLoading,
    this.error,
    this.errorMessage,
    this.itemBuilder,
    this.header,
    this.dataStream,
    this.onItemTap,
    this.listType = ListType.list,
    this.title = "No Title",
    this.description = "",
    this.showSliverAppBar = false,
  }) : super(key: key);

  void _fetchPage() async {
    await fetchData!();
  }

  Widget _getHeader() {
    if (header != null) {
      return Container(child: header);
    }
    return Container();
  }

  Widget _getFooter(BuildContext context) {
    if (nextLoading!) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (error!) {
      return _getError(context, errorMessage!);
    } else {
      return Container();
    }
  }

  Widget _getError(BuildContext context, String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error!", style: Theme.of(context).textTheme.headline4),
          Text(errorMessage),
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                fetchData!();
              })
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>?>(
      initialData: const [],
      stream: dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _getError(context, snapshot.error.toString());
        } else if (!loading! && snapshot.data!.isEmpty) {
          return _getError(context, "No Posts Found!");
        } else if (loading! && snapshot.data!.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return _getBody(context, snapshot.data!);
        }
      },
    );
  }

  Widget _getBody(BuildContext context, List<T> data) {
    return RefreshIndicator(
      onRefresh: () async {
        refresh!();
      },
      child: CustomScrollView(
        slivers: <Widget>[
          if (showSliverAppBar)
            SliverAppBar(
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title!,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          SliverToBoxAdapter(child: _getHeader()),
          _listOrGrid(
            listType: listType,
            delegate: SliverChildBuilderDelegate((context, index) {
              return GestureDetector(
                  onTap: () {
                    onItemTap!(context, index);
                  },
                  child: CreationAwareListItem(
                    itemCreated: () {
                      if (hasMore! && index == data.length - 10) {
                        _fetchPage();
                      }
                    },
                    child: itemBuilder!(data[index]),
                  ));
            }, childCount: data.length),
          ),
          SliverToBoxAdapter(child: _getFooter(context))
        ],
      ),
    );
  }

  Widget _listOrGrid(
      {required ListType listType,
      required SliverChildBuilderDelegate delegate}) {
    if (listType == ListType.grid) {
      return SliverGrid(
        delegate: delegate,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
      );
    }
    return SliverList(delegate: delegate);
  }
}
