import 'package:assignment/models/VideoData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<VideoData>> fetchAndParseData(int page, int limit) async {
  String apiUrl = 'https://api.ulearna.com/bytes/all?page= $page &limit= $limit &country=United+States';
  List<VideoData> videos = [];

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['statusCode'] == 200) {
        final List<dynamic> videoList = jsonResponse['data']['data'];
        for (var video in videoList) {
          VideoData item = VideoData(id: video['id'],//currently i didn't use this data.
              title: video['title'],
              cdnUrl: video['cdn_url'],
              thumbCdnUrl: video['thumb_cdn_url'],//currently i didn't use this data.
              uploaderName: video['user']['fullname'],
              orientation: video['orientation'],//currently i didn't use this data.
              total_views: video['total_views'],
              total_comments: video['total_likes'],
              total_likes: video['total_comments'],
              total_shares: video['total_share'],
              aspect_ratio: video['video_aspect_ratio'],//currently i didn't use this data.

          );
          videos.add(item);
          print('Title: ${item.title}');
          print('URL: ${item.cdnUrl}');
          print('Thumbnail: ${item.thumbCdnUrl}');
          print('Uploaded by: ${item.uploaderName}');
          print('Orientation: ${item.orientation}');
          print('total_views: ${item.total_views}');
          print('total_likes: ${item.total_likes}');
          print('total_shares: ${item.total_shares}');
          print('aspect_ratio: ${item.aspect_ratio}');

          print('--------------------------');
        }
      } else {
        print('Error: ${jsonResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
  return videos;
}