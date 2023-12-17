import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_story/bloc/story_bloc.dart';
import 'package:instagram_story/models/study_group.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final StoryBloc storyBloc;
  AppBloc({required this.storyBloc}) : super(AppInitial()) {
    on<StoryGroupPressed>((event, emit) {
      emit(AppLoaded(
          story_groups: StoryGroup.getStories(),
          currentStoryGroupIndex: event.group_index,
          isTransition: false));
    });
    on<NextStoryGroup>((event, emit) {
      if (state is AppLoaded) {
        final state = this.state as AppLoaded;
        final group_index = state.currentStoryGroupIndex;
        final story_groups = state.story_groups;
        if (group_index < story_groups.length - 1) {
          emit(AppLoaded(
              story_groups: story_groups,
              currentStoryGroupIndex: group_index + 1,
              isTransition: true));
          //Tell the story block to set its story index to 0
          storyBloc.add(SetStoryIndex(story_index: 0));
        } else {
          //This is the last story group there are no next story group
          emit(AppFinished());
        }
      }
    });
    on<PreviousStoryGroup>((event, emit) {
      if (state is AppLoaded) {
        final state = this.state as AppLoaded;
        final group_index = state.currentStoryGroupIndex;
        final story_groups = state.story_groups;
        if (0 < group_index) {
          emit(AppLoaded(
              story_groups: story_groups,
              currentStoryGroupIndex: group_index - 1,
              isTransition: true));
          //Tell the story block to set its story index to the previous groups last story index
          storyBloc.add(SetStoryIndex(
              story_index: story_groups[group_index - 1].stories.length - 1));
        } else {
          //This is the first story group.There are no previous story group
          emit(AppFinished());
        }
      }
    });
    on<SetTransitionToFalse>((event, emit) {
      if (state is AppLoaded) {
        final state = this.state as AppLoaded;
        emit(AppLoaded(
            currentStoryGroupIndex: state.currentStoryGroupIndex,
            story_groups: state.story_groups,
            isTransition: event.value));
      }
    });
  }
}
