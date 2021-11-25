// import 'package:anitrak/src/services/anilist/auth.dart';
import 'package:anitrak/src/services/anilist/queries.dart' as queries;
import 'package:graphql/client.dart';

class GraphqlRequestFailure implements Exception {}

class AnilistClient {
  const AnilistClient({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory AnilistClient.create() {
    final _httpLink = HttpLink('https://graphql.anilist.co/');
    // final _authLink = AuthLink(
    //   getToken: () async {
    //     final auth = AnilistAuth();
    //     final token = await auth.authenticate();
    //     return 'Bearer $token';
    //   },
    // );
    final link = Link.from([_httpLink]); //authLink.concat(_httpLink);
    return AnilistClient(
      graphQLClient: GraphQLClient(cache: GraphQLCache(), link: link),
    );
  }

  final GraphQLClient _graphQLClient;

  Future<Map<String, dynamic>> getMedia(
      {int? id, int page = 1, int perPage = 3, String? search}) async {
    var variables = <String, dynamic>{
      "search": search,
      "page": page,
      "perPage": perPage
    };
    if (id != null) {
      variables["id"] = id;
    }
    final result = await _graphQLClient.query(
      QueryOptions(
        document: gql(queries.getMedia),
        variables: variables,
      ),
    );

    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['Page'];
  }

  Future<Map<String, dynamic>> getMediaListCollection(
      int userId, String mediaType) async {
    final result = await _graphQLClient.query(
      QueryOptions(
        document: gql(queries.getMediaListCollection),
        variables: <String, dynamic>{
          'userId': userId,
          'type': mediaType
        }
      ),
    );

    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['MediaListCollection'];
  }
}
