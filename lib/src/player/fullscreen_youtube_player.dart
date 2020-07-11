// Copyright 2019 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../player/youtube_player.dart';
import '../utils/youtube_player_controller.dart';
import '../widgets/widgets.dart';

/// Shows [YoutubePlayer] in fullScreen landscape mode.
Future<void> showFullScreenYoutubePlayer({
  @required BuildContext context,
  @required YoutubePlayerController controller,
  EdgeInsetsGeometry actionsPadding,
  List<Widget> topActions,
  List<Widget> bottomActions,
  Widget bufferIndicator,
  Duration controlsTimeOut,
  Color liveUIColor,
  VoidCallback onReady,
  ProgressBarColors progressColors,
  Widget thumbnail,
}) async =>
    await Navigator.push(
      context,
      _YoutubePageRoute(
        builder: (context) => _FullScreenYoutubePlayer(
          controller: controller,
          actionsPadding: actionsPadding,
          topActions: topActions,
          bottomActions: bottomActions,
          bufferIndicator: bufferIndicator,
          controlsTimeOut: controlsTimeOut,
          liveUIColor: liveUIColor,
          onReady: onReady,
          progressColors: progressColors,
          thumbnail: thumbnail,
        ),
      ),
    );

class _FullScreenYoutubePlayer extends StatefulWidget {
  /// {@macro youtube_player_flutter.controller}
  final YoutubePlayerController controller;

  /// {@macro youtube_player_flutter.controlsTimeOut}
  final Duration controlsTimeOut;

  /// {@macro youtube_player_flutter.bufferIndicator}
  final Widget bufferIndicator;

  /// {@macro youtube_player_flutter.progressColors}
  final ProgressBarColors progressColors;

  /// {@macro youtube_player_flutter.onReady}
  final VoidCallback onReady;

  /// {@macro youtube_player_flutter.liveUIColor}
  final Color liveUIColor;

  /// {@macro youtube_player_flutter.topActions}
  final List<Widget> topActions;

  /// {@macro youtube_player_flutter.bottomActions}
  final List<Widget> bottomActions;

  /// {@macro youtube_player_flutter.actionsPadding}
  final EdgeInsetsGeometry actionsPadding;

  /// {@macro youtube_player_flutter.thumbnailUrl}
  final Widget thumbnail;

  _FullScreenYoutubePlayer({
    Key key,
    @required this.controller,
    this.controlsTimeOut = const Duration(seconds: 3),
    this.bufferIndicator,
    this.progressColors,
    this.onReady,
    this.liveUIColor = Colors.red,
    this.topActions,
    this.bottomActions,
    this.actionsPadding = const EdgeInsets.all(8.0),
    this.thumbnail,
  }) : super(key: key);

  @override
  _FullScreenYoutubePlayerState createState() =>
      _FullScreenYoutubePlayerState();
}

class _FullScreenYoutubePlayerState extends State<_FullScreenYoutubePlayer> {
  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: widget.controller,
      showVideoProgressIndicator: false,
      actionsPadding: widget.actionsPadding,
      bottomActions: widget.bottomActions,
      bufferIndicator: widget.bufferIndicator,
      controlsTimeOut: widget.controlsTimeOut,
      liveUIColor: widget.liveUIColor,
      onReady: widget.onReady,
      progressColors: widget.progressColors,
      thumbnail: widget.thumbnail,
      topActions: widget.topActions,
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => widget.controller.updateValue(
        widget.controller.value.copyWith(isFullScreen: true),
      ),
    );
    /*SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);*/
  }

  @override
  void dispose() {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => widget.controller.updateValue(
        widget.controller.value.copyWith(isFullScreen: false),
      ),
    );
    super.dispose();
  }
}

class _YoutubePageRoute<T> extends MaterialPageRoute<T> {
  _YoutubePageRoute({
    @required WidgetBuilder builder,
  }) : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
