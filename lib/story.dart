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
        body: Container(
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
                  return BlocBuilder<StoryBloc, StoryState>(
                      builder: (context, story_state) {
                    if (story_state is StoryShown) {
                      final curr_story_state = story_state;
                      return GestureDetector(
                        child: ShowImageOrVideo(
                            curr_story_state.storyIndex,
                            current_state.story_groups,
                            current_state.currentStoryGroupIndex),
                        onTapUp: (TapUpDetails details) {
                          double screenWidth =
                              MediaQuery.of(context).size.width;
                          bool isTappedOnLeft =
                              details.globalPosition.dx < screenWidth / 2;
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
        ));
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

// if (!(0 <= current_state.groupIndex &&
//                       current_state.groupIndex <=
//                           HomePage.Story_groups.length - 1)) {
//                     //group index out of bounds meaning there are no more groups to check
//                     //in the direction of prev/next
//                     // Schedule Navigator.pop after the current build cycle
//                     Future.delayed(Duration.zero, () {
//                       Navigator.pop(context);
//                     });
//                     //This is just a dummy container
//                     return Container(
//                       height: 0,
//                       width: 0,
//                     );
//                   } else {
//                     return GestureDetector(
//                       child: ShowImageOrVideo(state),
//                       onTapUp: (TapUpDetails details) {
//                         // Get the width of the screen
//                         double screenWidth = MediaQuery.of(context).size.width;

//                         // Determine if the tap was on the left or right side
//                         bool isTappedOnLeft =
//                             details.globalPosition.dx < screenWidth / 2;

//                         if (isTappedOnLeft) {
//                           context.read<StoryBloc>().add(PreviousStoryEvent());
//                         } else {
//                           context.read<StoryBloc>().add(NextStoryEvent());
//                         }
//                       },
//                     );
//                   }
