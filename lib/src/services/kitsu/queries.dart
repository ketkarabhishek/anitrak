// Queries
const fetchAllLibraryEntries = '''
query(\$id: ID!, \$mediaType: MediaTypeEnum!){
  findProfileById(id: \$id){
    library{
        all(first: 2000, mediaType: \$mediaType){
          nodes{
            ...MediaEntryFragment
            media{
              ...AnimeFragment
            }
          }
        }
      }
  }
}

$mediaEntryFragment

$animeFragment
''';

const searchMedia = '''
query(\$first: Int, \$after: String, \$title: String!, \$mediaType: MediaTypeEnum) {
  searchMediaByTitle(
    first: \$first
    after: \$after
    mediaType: \$mediaType
    title: \$title
  ) {
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
    nodes {
      ...AnimeFragment
    }
  }
}

$animeFragment
''';

const fetchCurrentUser = '''
query{
  session{
    profile{
      id
      avatarImage{
        original{
          url
        }
      }
      slug
    }
  }
}
''';


// Fragments
const mediaEntryFragment = '''
fragment MediaEntryFragment on LibraryEntry{
  id
  progress
  rating
  status
  reconsumeCount
  createdAt
  updatedAt
  startedAt
  finishedAt
}
''';

const animeFragment = '''
fragment AnimeFragment on Anime{
  id
  titles{
    romanized
  }
  description(locales: "en")
  episodeCount
  episodeLength
  season
  subtype
  status
  startDate
  posterImage{
    blurhash
    original{
      url
    }
  }
   bannerImage{
    views(names: ["large"]){
      url
    }
  }
}
''';