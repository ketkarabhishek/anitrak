const saveMediaListEntry = r'''
mutation ($id: Int, $mediaId: Int, $status: MediaListStatus, $score: Float, $progress: Int, $repeat: Int) {
  SaveMediaListEntry(id: $id, mediaId: $mediaId status: $status, score: $score, progress: $progress, repeat: $repeat) {
    id
  }
}
''';

const deleteMediaListEntry = r'''
mutation($id: Int){
  DeleteMediaListEntry(id: $id){
    deleted
  }
}
''';