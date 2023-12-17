// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    final ImagetotalDuration = 5; // in seconds
    final ImageupdateInterval = 0.02; // in seconds
    final ImagetotalSteps = (ImagetotalDuration / ImageupdateInterval).round();
    final ImageincrementValue = 1.0 / ImagetotalSteps;
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final StoryBloc storyBloc = BlocProvider.of<StoryBloc>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(context, appBloc),
        body: Column(
          children: [
            //This is the progression bar
            BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
              if (state is StoryShown) {
                final story_state = state;
                if (appBloc.state is AppLoaded) {
                  final app_state = appBloc.state as AppLoaded;
                  if (app_state.story_groups[app_state.currentStoryGroupIndex]
                      .stories[story_state.storyIndex]
                      .endsWith(".mp4")) {
                    //This is a video.//Adjust the timing accordingly.
                    return SizedBox.shrink();
                  } else {
                    //this is an image.Use 5 seconds for the progress bar.
                    if (story_state.isStopped) {
                      //Stop the progress
                      return LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        value: story_state.progress,
                        color: Colors.amber,
                      );
                    } else {
                      storyBloc.add(Progress(newProgress: ImageincrementValue));
                      return LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        value: story_state.progress,
                        color: Colors.amber,
                      );
                    }
                  }
                } else if (appBloc.state is AppFinished) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                } else {
                  throw Exception(
                      "Something went wrong with states.Check the Bloc structure");
                }
              } else {
                return SizedBox.shrink();
              }
            }),
            Expanded(
                child: BuildCurrentStoryContent(context, appBloc, storyBloc)),
          ],
        ));
  }

  Container BuildCurrentStoryContent(
      BuildContext context, AppBloc appBloc, StoryBloc storyBloc) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BlocBuilder<AppBloc, AppState>(builder: (context, app_state) {
            if (app_state is AppLoaded) {
              final current_state = app_state;
              final story_groups = current_state.story_groups;
              final group_index = current_state.currentStoryGroupIndex;
              if (current_state.isTransition) {
                //do the transition
                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateZ(value * (3.14 / 2))
                        ..scale(1.0 - value),
                      child: child,
                    );
                  },
                  onEnd: () {
                    //Set the transition in the app state to false
                    appBloc.add(SetTransitionToFalse(value: false));
                  },
                  child: CurrentStory(current_state, appBloc, storyBloc,
                      story_groups, group_index),
                );
              } else {
                //no transition.Just show the current story
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
          }),
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
        //check to see if the progress bar is full
        if (curr_story_state.progress == 1.0) {
          //go to the next story if not last else go to the next story group
          if (story_state.storyIndex ==
              story_groups[group_index].stories.length - 1) {
            //last story.Go next a story group
            appBloc.add(NextStoryGroup());
          } else {
            storyBloc.add(NextStory());
          }
        }
        return GestureDetector(
          child: story_groups[group_index]
                  .stories[story_state.storyIndex]
                  .endsWith(".mp4")
              ? ShowVideo(
                  curr_story_state.storyIndex, story_groups, group_index)
              : ShowImage(
                  curr_story_state.storyIndex, story_groups, group_index),
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
          onLongPress: () {
            //stop the progress bar
            storyBloc.add(SetStopped(stopped: true));
          },
          onLongPressEnd: (details) {
            //resume the progress bar
            storyBloc.add(SetStopped(stopped: false));
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

  Widget ShowImage(
      int story_index, List<StoryGroup> story_groups, int group_index) {
    //return an image
    return Image.asset(
      story_groups[group_index].stories[story_index],
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget ShowVideo(
      int story_index, List<StoryGroup> story_groups, int group_index) {
    //return an image
    return VideoPlayer(
        _createvideoController(story_groups[group_index].stories[story_index]));
  }

  VideoPlayerController _createvideoController(String videoPath) {
    _controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((__) => _controller.play());

    return _controller;
  }
}
