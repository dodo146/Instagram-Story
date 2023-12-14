import 'package:instagram_story/models/study_group.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  late final List<StoryGroup> StoryGroups;
  StoryBloc() : super(StoryInitial(story_groups: StoryGroup.getStories())) {
    StoryGroups = (state as StoryInitial).story_groups;

    on<StoryPressed>((event, emit) {
      emit(StoryShown(event.groupIndex, 0));
    });

    on<NextStoryEvent>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        final current_group_index = state.groupIndex;
        final current_story_group = StoryGroups[current_group_index];
        if (current_story_index < current_story_group.stories.length - 1) {
          //Still in the same story group.Increment the index
          emit(StoryShown(current_group_index, current_story_index + 1));
        } else {
          //stories finished.Go to the next story group if possible
          emit(StoryShown(current_group_index + 1, 0));
        }
      }
    });
    on<PreviousStoryEvent>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        final current_group_index = state.groupIndex;
        if (current_story_index > 0) {
          //Still in the same story group.Decrement the index
          emit(StoryShown(current_group_index, current_story_index - 1));
        } else {
          //stories finished.Go to the previous story group if possible
          emit(StoryShown(current_group_index - 1, 0));
        }
      }
    });
    on<NextStoryGroupEvent>((event, emit) {});
    on<PreviousStoryGroupEvent>((event, emit) {});
  }
}
