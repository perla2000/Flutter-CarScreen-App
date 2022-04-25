import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ApiYouTube {
  String ysearch = 'www.youtube.com';

  Map paths = {
    'search': '/results',
    'channel': '/channel',
    'music': '/music',
    'playlist': '/playlist'
  };

  var yt = YoutubeExplode();

  Future<List<Video>> playListSongs(String id) async {
    final List<Video> results = await yt.playlists.getVideos(id).toList();
    return results;
  }

  Future<Playlist> playlistMetaData(String id) async {
    final Playlist metadata = await yt.playlists.get(id);
    return metadata;
  }

  Future<List> searchSuggestions({required String searchQuery}) async {
    const searchUrl = 'https://suggestqueries-clients6.youtube.com/complete/search?client=firefox&q=';
    final Uri link = Uri.parse(searchUrl + searchQuery);

    const headers = {
      'User-Agent':
      'Mozilla/5.0 (Windows NT 10.0; rv:96.0) Gecko/20100101 Firefox/96.0'
    };

    try {
      final response = await get(link,headers: headers);

      if(response.statusCode == 200) {
       // print(response.body);
        final List searchSuggestion = jsonDecode(response.body);
        final List listOfSuggestions = searchSuggestion[1] ;


        // for(String i in listOfSuggestions){
        //   print(i);
        // }



        return listOfSuggestions;
      } else {
        return [];
      }

    } catch (e) {
      return [];
    }
  }


  Future<List<Video>> fetchSearchResults(String query) async {
    final List<Video> searchResults = await yt.search.getVideos(query);

    return searchResults;
  }

  Future<String> getUri(
    Video video,
    String quality,
    // {bool preferM4a = true}
  ) async {
    final StreamManifest manifest =
        await yt.videos.streamsClient.getManifest(video.id);
    final List<AudioOnlyStreamInfo> sortedStreamInfo =
        manifest.audioOnly.sortByBitrate();

    if (quality == 'High') {
      final AudioOnlyStreamInfo streamInfo = sortedStreamInfo.last;
      return streamInfo.url.toString();
    }
    final AudioOnlyStreamInfo streamInfo = sortedStreamInfo.first;
    return streamInfo.url.toString();
  }

  Future<Map<String, List>> ymusicHomePageData() async {
    final Uri link = Uri.https(
      ysearch,
      paths['music'].toString(),
    );
    final Response response = await get(link);
    if (response.statusCode != 200) {
      return {};
    }

    final String searchResults =
        RegExp(r'(\"contents\":{.*?}),\"metadata\"', dotAll: true)
            .firstMatch(response.body)![1]!;
    final Map data = json.decode('{$searchResults}') as Map;

    final List result = data['contents']['twoColumnBrowseResultsRenderer']
            ['tabs'][0]['tabRenderer']['content']['sectionListRenderer']
        ['contents'] as List;

    final List headResult = data['header']['carouselHeaderRenderer']['contents']
        [0]['carouselItemRenderer']['carouselItems'] as List;

    final List shelfRenderer = result.map((element) {
      return element['itemSectionRenderer']['contents'][0]['shelfRenderer'];
    }).toList();

    final List finalResult = shelfRenderer.map((element) {
      if (element['title']['runs'][0]['text'].trim() !=
          'Highlights from Global Citizen Live') {
        return {
          'title': element['title']['runs'][0]['text'],
          'playlists': element['title']['runs'][0]['text'].trim() == 'Charts'
              ? formatChartItems(
                  element['content']['horizontalListRenderer']['items'] as List,
                )
              : element['title']['runs'][0]['text']
                      .toString()
                      .contains('Music Videos')
                  ? formatVideoItems(
                      element['content']['horizontalListRenderer']['items']
                          as List,
                    )
                  : formatItems(
                      element['content']['horizontalListRenderer']['items']
                          as List,
                    ),
        };
      } else {
        return null;
      }
    }).toList();

    final List finalHeadResult = formatHeadItems(headResult);
    finalResult.removeWhere((element) => element == null);

    return {'body': finalResult, 'head': finalHeadResult};
  }

  List formatVideoItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridVideoRenderer']['title']['simpleText'],
          'type': 'video',
          'description': e['gridVideoRenderer']['shortBylineText']['runs'][0]
              ['text'],
          'count': e['gridVideoRenderer']['shortViewCountText']['simpleText'],
          'videoId': e['gridVideoRenderer']['videoId'],
          'firstItemId': e['gridVideoRenderer']['videoId'],
          'image':
              e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
          'imageMin': e['gridVideoRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['gridVideoRenderer']['thumbnail']['thumbnails'][1]
              ['url'],
          'imageStandard': e['gridVideoRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
          'imageMax':
              e['gridVideoRenderer']['thumbnail']['thumbnails'].last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatChartItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['gridPlaylistRenderer']['title']['runs'][0]['text'],
          'type': 'chart',
          'description': e['gridPlaylistRenderer']['shortBylineText']['runs'][0]
              ['text'],
          'count': e['gridPlaylistRenderer']['videoCountText']['runs'][0]
              ['text'],
          'playlistId': e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          'firstItemId': e['gridPlaylistRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageStandard': e['gridPlaylistRenderer']['thumbnail']['thumbnails']
              [0]['url'],
          'imageMax': e['gridPlaylistRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['compactStationRenderer']['title']['simpleText'],
          'type': 'playlist',
          'description': e['compactStationRenderer']['description']
              ['simpleText'],
          'count': e['compactStationRenderer']['videoCountText']['runs'][0]
              ['text'],
          'playlistId': e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['playlistId'],
          'firstItemId': e['compactStationRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['compactStationRenderer']['thumbnail']['thumbnails'][0]
              ['url'],
          'imageMedium': e['compactStationRenderer']['thumbnail']['thumbnails']
              [0]['url'],
          'imageStandard': e['compactStationRenderer']['thumbnail']
              ['thumbnails'][1]['url'],
          'imageMax': e['compactStationRenderer']['thumbnail']['thumbnails'][2]
              ['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  List formatHeadItems(List itemsList) {
    try {
      final List result = itemsList.map((e) {
        return {
          'title': e['defaultPromoPanelRenderer']['title']['runs'][0]['text'],
          'type': 'video',
          'description':
              (e['defaultPromoPanelRenderer']['description']['runs'] as List)
                  .map((e) => e['text'])
                  .toList()
                  .join(),
          'videoId': e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'firstItemId': e['defaultPromoPanelRenderer']['navigationEndpoint']
              ['watchEndpoint']['videoId'],
          'image': e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
          'imageMedium': e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][1]['url'],
          'imageStandard': e['defaultPromoPanelRenderer']
                      ['largeFormFactorBackgroundThumbnail']
                  ['thumbnailLandscapePortraitRenderer']['landscape']
              ['thumbnails'][2]['url'],
          'imageMax': e['defaultPromoPanelRenderer']
                          ['largeFormFactorBackgroundThumbnail']
                      ['thumbnailLandscapePortraitRenderer']['landscape']
                  ['thumbnails']
              .last['url'],
        };
      }).toList();

      return result;
    } catch (e) {
      return List.empty();
    }
  }

  Future<Map?> formatVideo({
    required Video video,
    String quality = 'High',
    // bool preferM4a = true,
  }) async {
    if (video.duration?.inSeconds == null) return null;
    return {
      'id': video.id.value,
      'album': video.author,
      'duration': video.duration?.inSeconds.toString(),
      'title': video.title,
      'artist': video.author,
      'image': video.thumbnails.maxResUrl,
      'secondImage': video.thumbnails.highResUrl,
      'language': 'YouTube',
      'genre': 'YouTube',
      'url': await getUri(video, quality),
      'year': video.uploadDate?.year.toString(),
      '320kbps': 'false',
      'has_lyrics': 'false',
      'release_date': video.publishDate.toString(),
      'album_id': video.channelId.value,
      'subtitle': video.author,
      'perma_url': video.url,
    };
  }
}
