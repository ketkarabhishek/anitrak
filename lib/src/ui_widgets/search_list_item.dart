import 'package:anitrak/src/models/media_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({Key? key, required this.mediaModel}) : super(key: key);

  final MediaModel mediaModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: mediaModel.poster,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mediaModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
