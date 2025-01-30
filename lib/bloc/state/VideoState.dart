import 'package:assignment/models/VideoData.dart';

abstract class VideoState {}

class VideoInitialState extends VideoState {}

class VideoLoadingState extends VideoState {}

class VideoLoadedState extends VideoState {
  final List<VideoData> videos;
  final bool hasMore;
  VideoLoadedState({required this.videos, required this.hasMore});
}

class VideoErrorState extends VideoState {
  final String message;
  VideoErrorState(this.message);
}