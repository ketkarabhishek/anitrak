class Media {
  final int id;
  final String title;
  final String poster;
  Media(this.id, this.title, this.poster);

  Media.fromJson(Map<String, dynamic> json)
  : id = json['id'],
    title = json['title']['romaji'],
    poster = json['coverImage']['large'];

  Media.fromAnilistJson(Map<String, dynamic> json)
  : id = json['id'],
    title = json['title']['romaji'],
    poster = json['coverImage']['large'];
}