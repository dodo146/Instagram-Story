// ignore_for_file: must_be_immutable
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story/bloc/story_bloc.dart';
import 'package:instagram_story/home.dart';
import 'package:video_player/video_player.dart';

class StoryPage extends StatelessWidget {
  StoryPage({super.key, required this.index});
  final int index;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
                if (state is StoryShown) {
                  final current_state = state;
                  if (!(0 <= current_state.groupIndex &&
                      current_state.groupIndex <=
                          HomePage.Story_groups.length - 1)) {
                    //group index out of bounds meaning there are no more groups to check
                    //in the direction of prev/next
                    // Schedule Navigator.pop after the current build cycle
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                    //This is just a dummy container
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  } else {
                    return GestureDetector(
                      child: ShowImageOrVideo(current_state),
                      onTapUp: (TapUpDetails details) {
                        // Get the width of the screen
                        double screenWidth = MediaQuery.of(context).size.width;

                        // Determine if the tap was on the left or right side
                        bool isTappedOnLeft =
                            details.globalPosition.dx < screenWidth / 2;

                        if (isTappedOnLeft) {
                          context.read<StoryBloc>().add(PreviousStoryEvent());
                        } else {
                          context.read<StoryBloc>().add(NextStoryEvent());
                        }
                      },
                    );
                  }
                } else {
                  throw Exception(
                      "Something went wrong with states.Check the Bloc structure");
                }
              })
            ],
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "Story",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
    );
  }

  Widget ShowImageOrVideo(StoryShown state) {
    if (HomePage.Story_groups[state.groupIndex].stories[state.storyIndex]
        .endsWith(".mp4")) {
      //return a video
      return VideoPlayer(_createChewieController(
              HomePage.Story_groups[state.groupIndex].stories[state.storyIndex])
          .videoPlayerController);
    } else {
      //return an image
      return Image.asset(
        HomePage.Story_groups[state.groupIndex].stories[state.storyIndex],
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

// ValueListenableBuilder(
//                 valueListenable: index,
//                 builder: (context, value, child) {
//                   return GestureDetector(
//                     child: ShowImageOrVideo(),
//                     onTap: () {
//                       if (value < stories.length - 1) {
//                         index.value++;
//                       } else {
//                         // ignore: unnecessary_null_comparison
//                         if (_chewieController != null) {
//                           if (!_chewieController.isPlaying) {
//                             Navigator.pop(context);
//                           }
//                         }
//                       }
//                     },
//                   );
//                 },
//               ),
