abstract class VideoEvent {}

class FetchVideosEvent extends VideoEvent {}
class scrollToNewVideo extends VideoEvent {}
class RemoveLoading extends VideoEvent {}
class Loading extends VideoEvent {}
