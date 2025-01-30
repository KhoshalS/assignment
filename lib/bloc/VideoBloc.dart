import 'package:assignment/api/FetchData.dart';
import 'package:assignment/bloc/events/VideoEvent.dart';
import 'package:assignment/bloc/state/VideoState.dart';
import 'package:assignment/models/VideoData.dart';
import 'package:bloc/bloc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  int page = 0;//when user scroll the page counter will be increased. each page will load limit integer items. currently(10)
  final int limit = 10;//here we can modify the limit of items we retrive from ulearna api. i will let it to be 10. as default we get in assignment.
  bool isFetching = false;
  List<VideoData> videos = [];//this list will store VideoData for all videos which will we get from APi. the more user scroll the more data will be added to this list.


  VideoBloc() : super(VideoInitialState()) {
    on<FetchVideosEvent>((event, emit) async {

      print("__PRINT__EventIsCalled!");
      if (isFetching) return;
      isFetching = true;
      try {

        page++;
        final videos = await fetchAndParseData(page, limit);
        final hasMore = videos.length == limit;

        if (state is VideoLoadedState) {
          final currentVideos = (state as VideoLoadedState).videos;
          emit(VideoLoadedState(
            videos: currentVideos + videos,
            hasMore: hasMore,
          ));
        } else {
          emit(VideoLoadedState(videos: videos, hasMore: hasMore));
        }
      } catch (e) {
        emit(VideoErrorState(e.toString()));
      } finally {
        isFetching = false;
      }
    });
  }
}