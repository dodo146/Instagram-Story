part of 'story_bloc.dart';

sealed class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

final class StoryInitial extends StoryState {
  final List<StoryGroup> story_groups;
  StoryInitial({required this.story_groups});

  @override
  List<Object> get props => [story_groups];
}

final class StoryShown extends StoryState {
  final int groupIndex;
  final int storyIndex;

  StoryShown(this.groupIndex, this.storyIndex);

  @override
  List<Object> get props => [groupIndex, storyIndex];
}
