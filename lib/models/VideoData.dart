class VideoData {
  final int id;
  final String title;
  final String cdnUrl;
  final String thumbCdnUrl;
  final String uploaderName;
  final String orientation;
  final int total_views;
  final int total_likes;
  final int total_comments;
  final int total_shares;
  final String aspect_ratio;

  VideoData({
    required this.id,
    required this.title,
    required this.cdnUrl,
    required this.thumbCdnUrl,
    required this.uploaderName,
    required this.orientation,
    required this.total_views,
    required this.total_likes,
    required this.total_comments,
    required this.total_shares,
    required this.aspect_ratio,
  });

}
