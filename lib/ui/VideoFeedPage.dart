import 'package:assignment/models/VideoData.dart';
import 'package:assignment/ui/VideoPlayerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/bloc/VideoBloc.dart';
import 'package:assignment/bloc/events/VideoEvent.dart';
import 'package:assignment/bloc/state/VideoState.dart';
import 'package:assignment/ui/VideoPlayerWidget.dart';
import 'package:cached_video_player/cached_video_player.dart';

class VideoFeedPage extends StatefulWidget {
  const VideoFeedPage({Key? key}) : super(key: key);

  @override
  _VideoFeedPageState createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<int, CachedVideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<VideoBloc>(context).add(FetchVideosEvent());
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page == _currentPage.toDouble()) return;

    setState(() {
      _currentPage = _pageController.page!.toInt();
    });

    final videoBloc = context.read<VideoBloc>();
    final currentState = videoBloc.state;

    if (currentState is VideoLoadedState) {
      // here we fetch more videos when nearing the end of the list
      if (_currentPage >= currentState.videos.length - 2) {
        videoBloc.add(FetchVideosEvent());
      }

      // Disposing of unused controllers
      _disposeUnusedControllers(_currentPage);
    }
  }

  void _disposeUnusedControllers(int currentIndex) {
    _controllers.removeWhere((index, controller) {
      if (index < currentIndex - 1 || index > currentIndex + 1) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoInitialState || state is VideoLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VideoLoadedState) {
            final videos = state.videos;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildVideoPlayer(videos[index], index),

                    Positioned(
                      bottom: 100,
                      left: 10,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 20,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.5), // 0.5 is added to give a Semi-transparent black background
                            borderRadius: BorderRadius.circular(8), // i think rounded corner will look cool and eye comporting
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Following Text() widget is used for title of the video (+with wrapping)
                              Text(
                                video.title,
                                style: TextStyle(color: Colors.white, fontSize: 18),
                                overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
                                maxLines: 2,
                                softWrap: true,
                              ),
                              // Uploader name:
                              Text(
                                'Uploaded by: ${video.uploaderName}',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  _buildMetric(Icons.thumb_up_sharp, video.total_likes),
                                  SizedBox(width: 15),
                                  _buildMetric(Icons.comment, video.total_comments),
                                  SizedBox(width: 15),
                                  _buildMetric(Icons.visibility, video.total_views),
                                  SizedBox(width: 15),
                                  _buildMetric(Icons.share, video.total_shares),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          } else if (state is VideoErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<VideoBloc>(context)
                          .add(FetchVideosEvent());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

// Helper method for building metrics.
  Widget _buildMetric(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        SizedBox(width: 5), // Add spacing between icon and text
        Text(
          '$count',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(VideoData video, int index) {
    // Here we check if the controller already exists
    if (!_controllers.containsKey(index)) {
      // lets create a new controller
      final CachedVideoPlayerController controller =
          CachedVideoPlayerController.network(video.cdnUrl);

      // and lets now Initialize the controller
      controller.initialize().then((_) {
        if (mounted &&
            index == _currentPage &&
            controller.value.isInitialized) {
          // Play only if the controller is initialized and the video is visible
          controller.play();
        }
      }).catchError((error) {
        print(
            'Error initializing video player for video ${video.cdnUrl}: $error');
      });

      _controllers[index] = controller;
    }

    // here we retrieve the controller from the mapList(mapList store all controllers). and will dispose if it get too far. (-1,+1)
    final CachedVideoPlayerController controller = _controllers[index]!;
    controller.setLooping(true);

    return VideoPlayerWidget(
        controller: controller,
        isVisible: index == _currentPage
    );
  }
}
