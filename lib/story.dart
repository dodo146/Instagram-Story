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
    final totalDuration = 5; // in seconds
    final updateInterval = 0.02; // in seconds
    final totalSteps = (totalDuration / updateInterval).round();
    final incrementValue = 1.0 / totalSteps;
    final AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    final StoryBloc storyBloc = BlocProvider.of<StoryBloc>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(context, appBloc),
        body: Column(
          children: [
            BlocBuilder<StoryBloc, StoryState>(builder: (context, state) {
              if (state is StoryShown) {
                final curr_state = state;
                storyBloc.add(Progress(newProgress: incrementValue));
                return LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  value: curr_state.progress,
                  color: Colors.amber,
                );
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
          //LinearProgressIndicator(),
          BlocBuilder<AppBloc, AppState>(builder: (context, app_state) {
            if (app_state is AppLoaded) {
              final current_state = app_state;
              final story_groups = current_state.story_groups;
              final group_index = current_state.currentStoryGroupIndex;
              return CurrentStory(
                  current_state, appBloc, storyBloc, story_groups, group_index);
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
