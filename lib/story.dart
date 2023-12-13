// ignore_for_file: must_be_immutable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
//Şimdilik ValueListenableBuilder var story state'i kontrol etmek için
//Ekrana basınca index arttırılır ve index değişince builder tekrar build eder çünkü dinlediği değer değişir.
//En son ama bloc kullan bütün stateler için.

class StoryPage extends StatelessWidget {
  StoryPage({super.key, required this.stories});
  final List<String> stories;
  final ValueNotifier<int> index = ValueNotifier<int>(0);
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Story",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) {
                  return GestureDetector(
                    child: ShowImageOrVideo(),
                    onTap: () {
                      if (value < stories.length - 1) {
                        index.value++;
                      } else {
                        // ignore: unnecessary_null_comparison
                        if (_chewieController != null) {
                          if (!_chewieController.isPlaying) {
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ));
  }

  Widget ShowImageOrVideo() {
    if (stories[index.value].endsWith(".mp4")) {
      //return a video
      return VideoPlayer(
          _createChewieController(stories[index.value]).videoPlayerController);
    } else {
      //return an image
      return Image.asset(
        stories[index.value],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  ChewieController _createChewieController(String videoPath) {
    _controller = VideoPlayerController.asset(videoPath);
    _chewieController = ChewieController(
        videoPlayerController: _controller, autoPlay: true, looping: false);

    return _chewieController;
  }
}
// child: GestureDetector(
                //   child: Image.asset(
                //     stories[index.value],
                //     fit: BoxFit.cover,
                //     width: double.infinity,
                //     height: double.infinity,
                //   ),
                //   onTap: () {
                //     //block state lazım hangi storyde olduğunu bilmek için
                //     if (index.value < stories.length - 1) {
                //       index.value++;
                //     } else {
                //       //storyler bitti
                //       Navigator.pop(context);
                //     }
                //   },
                // ),