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
    media (id: $id, search: $search, type: ANIME, sort: POPULARITY_DESC) {
      id
      description
      duration
      title {
        romaji
      }
      coverImage{
        large
        color
      }
      episodes
      status
      format
      season
      seasonYear
      bannerImage
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
        startedAt {
          year
          month
          day
        }
        completedAt {
          year
          month
          day
        }
        media {
          id
          description
          duration
          title {
            romaji
          }
          coverImage {
            large
            color
          }
          episodes
          status
          format
          season
          seasonYear
          bannerImage
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
