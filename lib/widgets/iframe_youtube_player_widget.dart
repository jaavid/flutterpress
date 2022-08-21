import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({Key? key, required this.youtubeVideoUrl})
      : super(key: key);
  final String youtubeVideoUrl;

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  static getYoutubeVideoIdFromUrl (String videoUrl){
    return YoutubePlayerController.convertUrlToId(videoUrl);
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: getYoutubeVideoIdFromUrl(widget.youtubeVideoUrl),
        params: YoutubePlayerParams(
          autoPlay: false,
          desktopMode: false,
          loop: true,
          showControls: true,
          enableCaption: false,
          showFullscreenButton: true,
          useHybridComposition: true,
          strictRelatedVideos: true,
          showVideoAnnotations: false,
          privacyEnhanced: true,
        ))
      ..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            ..hideTopMenu();
        }
      });

    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };

    _controller.onExitFullscreen = (){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    };
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Container(
        child: Stack(
          children: [
            player,
            Positioned.fill(
              child: YoutubeValueBuilder(
                controller: _controller,
                builder: (context, value) {
                  return AnimatedCrossFade(
                    firstChild: SizedBox.shrink(),
                    secondChild: Container(
                      color: Colors.black,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                    ),
                    crossFadeState: value.isReady
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 200),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}