import 'package:anitrak/src/pages/search_page.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      child: const ListTile(
        title: Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.search),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search...',
                    ),
                    // textAlign: TextAlign.start,
                    // style: TextStyle(fontSize: 18),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(50);
}
