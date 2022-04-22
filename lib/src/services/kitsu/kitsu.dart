import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:dio/dio.dart';
import 'package:anitrak/src/env.dart' as env;
import 'package:graphql/client.dart';
import 'package:anitrak/src/services/kitsu/queries.dart' as queries;
import 'package:anitrak/src/services/kitsu/mutations.dart' as mutations;

class Kitsu {
  const Kitsu({required GraphQLClient graphQLClient})
      : _graphQLClient = graphQLClient;

  factory Kitsu.create({required PreferencesRepo repo}) {
    final _httpLink = HttpLink('https://kitsu.io/api/graphql');
    final _authLink = AuthLink(
      getToken: () async {
        final authToken = await repo.kitsuAccessToken;
        return authToken != null ? 'Bearer $authToken' : null;
      },
    );
    final link = _authLink.concat(_httpLink);
    return Kitsu(
      graphQLClient: GraphQLClient(cache: GraphQLCache(), link: link),
    );
  }

  final GraphQLClient _graphQLClient;

  Future<Map<String, dynamic>> getLibrary(
      {required int userId, String mediaType = "ANIME"}) async {
    final result = await _graphQLClient.query(
      QueryOptions(
          errorPolicy: ErrorPolicy.all,
          document: gql(queries.fetchAllLibraryEntries),
          variables: {"id": userId, "mediaType": mediaType}),
    );

    // if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['findProfileById']['library']['all'];
  }

  Future<Map<String, dynamic>> getMedia(
      {int first = 20,
      String mediaType = "ANIME",
      String title = "",
      String? after}) async {
    final result = await _graphQLClient.query(
      QueryOptions(
          document: gql(queries.searchMedia),
          variables: <String, dynamic>{
            'first': first,
            'mediaType': mediaType,
            'after': after,
            'title': title
          }),
    );

    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['searchMediaByTitle'];
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final result = await _graphQLClient.query(
      QueryOptions(document: gql(queries.fetchCurrentUser)),
    );
    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['session']['profile'];
  }

  Future<int> createLibraryEntry(Map<String, dynamic> mediaEntryData) async {
    final result = await _graphQLClient.mutate(
      MutationOptions(
          document: gql(mutations.createLibraryEntry),
          variables: {"input": mediaEntryData}),
    );
    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['libraryEntry']['create']['libraryEntry']['id'];
  }

   Future<int> updateLibraryEntry(Map<String, dynamic> mediaEntryData) async {
    final result = await _graphQLClient.mutate(
      MutationOptions(
          document: gql(mutations.updateLibraryEntry),
          variables: {"input": mediaEntryData}),
    );
    if (result.hasException) throw GraphqlRequestFailure();
    return int.parse(result.data?['libraryEntry']['update']['libraryEntry']['id'] );
  }

  Future<int> deleteLibraryEntry(Map<String, dynamic> mediaEntryData) async {
    final result = await _graphQLClient.mutate(
      MutationOptions(
          document: gql(mutations.deleteLibraryEntry),
          variables: {"input": mediaEntryData}),
    );
    if (result.hasException) throw GraphqlRequestFailure();
    return result.data?['libraryEntry']['delete']['libraryEntry']['id'];
  }

  // Auth
  static Future<Map<String, dynamic>> authenticate(
      {required String userName, required String password}) async {
    try {
      final response = await Dio().post(
        "https://kitsu.io/api/oauth/token",
        data: {
          'grant_type': 'password',
          'client_id': env.kitsutClientId,
          'client_secret': env.kitsuClientSecret,
          'username': userName,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw e.toString();
    }
  }
}
