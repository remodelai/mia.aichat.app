import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AduioMessage extends StatefulWidget {
  final String filepath;
  const AduioMessage({
    Key? key,
    required this.filepath,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AduioMessageState createState() => _AduioMessageState();
}

class _AduioMessageState extends State<AduioMessage>
    with TickerProviderStateMixin {
  var leftSoundNames = [
    'images/chat/sound_left_0.webp',
    'images/chat/sound_left_1.webp',
    'images/chat/sound_left_2.webp',
    'images/chat/sound_left_3.webp',
  ];

  var rightSoundNames = [
    'images/chat/sound_right_0.png',
    'images/chat/sound_right_1.webp',
    'images/chat/sound_right_2.webp',
    'images/chat/sound_right_3.png',
  ];

  late Animation _animation;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _audioPlayer = AudioPlayer();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void initAudioPlayer() {
    final Animation<double> curve =
        CurvedAnimation(parent: _controller, curve: Curves.linear);
    _animation = IntTween(begin: 0, end: 4).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.addListener(() {
      setState(() {});
    });

    // Listen for audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      log("liliwei Player state changed: $state");
      // Update the UI or perform other actions based on player state
    });

    // // Listen for audio playback completion
    _audioPlayer.onPlayerComplete.listen((event) {
      log("liliwei Playback completed");
      _controller.stop();
      _controller.reset();
      // Perform actions on playback completion, like resetting the UI
    });

    // // Listen for errors
    // audioPlayer.onPlayerError.listen((String error) {
    //   print("An error occurred in the audio player: $error");
    //   // Handle the error, maybe by showing an error message
    // });

    // // Example for position updates
    // audioPlayer.onAudioPositionChanged.listen((Duration position) {
    //   print("Current position: $position");
    //   // Update the UI based on playback position, like updating a progress bar
    // });

    // // Example for duration changes
    // audioPlayer.onDurationChanged.listen((Duration duration) {
    //   print("Duration of the audio: $duration");
    //   // Update the UI based on audio duration, like setting the max value of a progress bar
    // });

//
//    _audioPlayerStateSubscription =
//        flutterSound.onPlayerStateChanged.listen((s) {
//      if (s != null) {
//      } else {
//        controller.reset();
//        setState(() {
//          position = duration;
//        });
//      }
//    }, onError: (msg) {
//      setState(() {
//        duration = new Duration(seconds: 0);
//        position = new Duration(seconds: 0);
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> body = [_buttonPreview()];
    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
    //   child: Row(children: body),
    // );
    return VoiceMessageView(
      controller: VoiceController(
        audioSrc: widget.filepath,
        maxDuration: const Duration(seconds: 20),
        isFile: true,
        onComplete: () {},
        onPause: () {},
        onPlaying: () {},
        onError: (err) {},
      ),
    );
  }

  _buttonPreview() {
    var isSelf = true;
    var soundImg = rightSoundNames;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.only(left: 18.0, right: 4.0),
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        playNew();
        _controller.forward();
      },
      child: Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          SizedBox(width: 100),
          Container(
            width: 20,
            height: 20,
            child: Image.asset(soundImg[_animation.value % 4],
                height: 20.0, color: Colors.black, fit: BoxFit.cover),
          ),

          //Spacer(width: mainSpace)
        ],
      ),
    );
  }

  playNew() async {
    log("liliwei playNew: ${widget.filepath}");
    await _audioPlayer.setSourceDeviceFile(widget.filepath);
    await _audioPlayer.resume();
    _controller.forward();
  }
}
