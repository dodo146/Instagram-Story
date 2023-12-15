// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story/bloc/app_bloc.dart';
import 'package:instagram_story/bloc/story_bloc.dart';
import 'package:instagram_story/models/study_group.dart';
import 'package:video_player/video_player.dart';

class StoryPage extends StatelessWidget {
  StoryPage({super.key, required this.index});
  final int index;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  Widget build(BuildContext context) {
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final StoryBloc storyBloc = BlocProvider.of<StoryBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context, appBloc),
        body: BuildCurrentStoryContent(context, appBloc, storyBloc));
  }

  Container BuildCurrentStoryContent(
      BuildContext context, AppBloc appBloc, StoryBloc storyBloc) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LinearProgressIndicator(),
          BlocBuilder<AppBloc, AppState>(builder: (context, app_state) {
            if (app_state is AppLoaded) {
              final current_state = app_state;
              final story_groups = current_state.story_groups;
              final group_index = current_state.currentStoryGroupIndex;
              final prev_index = current_state.prev_index;
              if (group_index != prev_index) {
                //the transition
                return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 500),
                    child: CurrentStory(current_state, appBloc, storyBloc,
                        story_groups, group_index),
                    builder: (context, dynamic animationValue, child) {
                      final double angle =
                          animationValue * (3.14 / 2); // 90 degrees
                      final double scale = 1.0 - animationValue;
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateZ(angle)
                          ..scale(scale),
                        child: child,
                      );
                    });
              } else {
                //No transition
                return CurrentStory(current_state, appBloc, storyBloc,
                    story_groups, group_index);
              }
            } else if (app_state is AppFinished) {
              //Go back to the main page
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
              return Container(
                height: 0,
                width: 0,
              );
            } else {
              throw Exception(
                  "Something went wrong with states.Check the Bloc structure");
            }
          })
        ],
      ),
    );
  }

  BlocBuilder<StoryBloc, StoryState> CurrentStory(
      AppLoaded current_state,
      AppBloc appBloc,
      StoryBloc storyBloc,
      List<StoryGroup> story_groups,
      int group_index) {
    return BlocBuilder<StoryBloc, StoryState>(builder: (context, story_state) {
      if (story_state is StoryShown) {
        final curr_story_state = story_state;
        return GestureDetector(
          child: ShowImageOrVideo(curr_story_state.storyIndex,
              current_state.story_groups, current_state.currentStoryGroupIndex),
          onTapUp: (TapUpDetails details) {
            double screenWidth = MediaQuery.of(context).size.width;
            bool isTappedOnLeft = details.globalPosition.dx < screenWidth / 2;
            if (isTappedOnLeft) {
              //check if there is a previous story
              if (0 == story_state.storyIndex) {
                //last story.Go back a story group
                appBloc.add(PreviousStoryGroup());
              } else {
                storyBloc.add(PreviousStory());
              }
            } else {
              //User tapped on right
              if (story_state.storyIndex ==
                  story_groups[group_index].stories.length - 1) {
                //last story.Go next a story group
                appBloc.add(NextStoryGroup());
                ;
              } else {
                storyBloc.add(NextStory());
              }
            }
          },
        );
      } else {
        throw Exception(
            "Something went wrong with states.Check the Bloc structure");
      }
    });
  }

  AppBar appBar(BuildContext context, AppBloc appBloc) {
    return AppBar(
      title: BlocBuilder<AppBloc, AppState>(
        builder: (appContext, appState) {
          if (appState is AppLoaded) {
            // Access the information about the current story group
            final storyGroup =
                appState.story_groups[appState.currentStoryGroupIndex];

            // Use storyGroup.attribute as needed in the title
            return Text(
              "Story of ${storyGroup.name}",
              style: TextStyle(color: Colors.white),
            );
          } else {
            return Text("Story", style: TextStyle(color: Colors.white));
          }
        },
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
    );
  }

  Widget ShowImageOrVideo(
      int story_index, List<StoryGroup> story_groups, int group_index) {
    if (story_groups[group_index].stories[story_index].endsWith(".mp4")) {
      //return a video
      return VideoPlayer(_createChewieController(
              story_groups[group_index].stories[story_index])
          .videoPlayerController);
    } else {
      //return an image
      return Image.asset(
        story_groups[group_index].stories[story_index],
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
