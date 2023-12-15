part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

final class AppInitial extends AppState {}

final class AppLoaded extends AppState {
  final List<StoryGroup> story_groups;
  final int currentStoryGroupIndex;
  final int prev_index;
  AppLoaded(
      {required this.story_groups,
      required this.currentStoryGroupIndex,
      required this.prev_index});

  @override
  List<Object> get props => [story_groups, currentStoryGroupIndex];
}

final class AppFinished extends AppState {}
