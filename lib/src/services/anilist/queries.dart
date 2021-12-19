const getMedia = r'''
query ($id: Int, $page: Int, $perPage: Int, $search: String) {
  Page (page: $page, perPage: $perPage) {
    pageInfo {
      total
      currentPage
      lastPage
      hasNextPage
      perPage
    }
    media (id: $id, search: $search) {
      id
      title {
        romaji
      }
      coverImage{
        large
        color
      }
    }
  }
}
''';

const getMediaList = r'''
query ($id: Int, $page: Int, $perPage: Int, $userId: Int, $userName: String, $type: MediaType, $status: MediaListStatus, $mediaId: Int) {
  Page (page: $page, perPage: $perPage) {
    pageInfo {
      total
      currentPage
      lastPage
      hasNextPage
      perPage
    }
    mediaList (id: $id, userId: $userId, userName: $userName, type: $type, status: $status, mediaId: $mediaId) {
      id
      mediaId
      status
      score
      progress
      repeat
      createdAt
      updatedAt
      media{
        title {
          romaji
        }
        coverImage{
          large
          color
        }
      }
    }
  }
}
''';

const getMediaListCollection = r'''
query ($userId: Int, $type: MediaType) {
  MediaListCollection(userId: $userId, type: $type) {
    lists {
      name
      isCustomList
      isSplitCompletedList
      status
      entries {
        id
        mediaId
        status
        score
        progress
        repeat
        createdAt
        updatedAt
        media {
          title {
            romaji
          }
          coverImage {
            large
            color
          }
          episodes
        }
      }
    }
    hasNextChunk
  }
}

''';

const getCurrentUserId = r'''
query{
  Viewer{
    id
    name
    avatar {
      medium
    }
  }
}
''';
