const saveMediaListEntry = r'''
mutation ($id: Int, $status: MediaListStatus, $score: Float, $progress: Int, $repeat: Int) {
  SaveMediaListEntry(id: $id, status: $status, score: $score, progress: $progress, repeat: $repeat) {
    id
  }
}
''';