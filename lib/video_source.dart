enum VideoSourceType { mp4, youtube }

/// Abstraction over where a lesson's video comes from, so LessonScreen
/// does not need to know playback details for each provider.
class VideoSource {
  final VideoSourceType type;
  final String? url; // used when type == mp4
  final String? youtubeVideoId; // used when type == youtube

  const VideoSource.mp4(String this.url)
      : type = VideoSourceType.mp4,
        youtubeVideoId = null;

  const VideoSource.youtube(String this.youtubeVideoId)
      : type = VideoSourceType.youtube,
        url = null;
}
