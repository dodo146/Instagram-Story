import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on<LoadStory>((event, emit) {
      emit(StoryShown(0));
    });
    on<NextStory>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        emit(StoryShown(current_story_index + 1));
      }
    });
    on<PreviousStory>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        emit(StoryShown(current_story_index - 1));
      }
    });
    on<SetStoryIndex>((event, emit) {
      if (state is StoryShown) {
        emit(StoryShown(event.story_index));
      }
    });
  }
}
