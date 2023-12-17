import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on<LoadStory>((event, emit) {
      emit(StoryShown(storyIndex: 0, progress: 0.0, isStopped: false));
    });
    on<NextStory>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        emit(StoryShown(
            storyIndex: current_story_index + 1,
            progress: 0.0,
            isStopped: false));
      }
    });
    on<PreviousStory>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        final current_story_index = state.storyIndex;
        emit(StoryShown(
            storyIndex: current_story_index - 1,
            progress: 0.0,
            isStopped: false));
      }
    });
    on<SetStoryIndex>((event, emit) {
      if (state is StoryShown) {
        emit(StoryShown(
            storyIndex: event.story_index, progress: 0.0, isStopped: false));
      }
    });
    on<Progress>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        if (state.progress >= 1.0) {
          emit(StoryShown(
              storyIndex: state.storyIndex, progress: 1.0, isStopped: true));
        } else {
          emit(StoryShown(
              storyIndex: state.storyIndex,
              progress: state.progress + event.newProgress,
              isStopped: false));
        }
      }
    });
    on<SetStopped>((event, emit) {
      if (state is StoryShown) {
        final state = this.state as StoryShown;
        emit(StoryShown(
            storyIndex: state.storyIndex,
            progress: state.progress,
            isStopped: event.stopped));
      }
    });
  }
}
