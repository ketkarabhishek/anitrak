const saveMediaListEntry = r'''
mutation ($id: Int, $mediaId: Int, $status: MediaListStatus, $score: Float, $progress: Int, $repeat: Int) {
  SaveMediaListEntry(id: $id, mediaId: $mediaId, status: $status, score: $score, progress: $progress, repeat: $repeat) {
    id
  }
}
''';