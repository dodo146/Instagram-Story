// ignore_for_file: must_be_immutable

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
  AppLoaded({required this.story_groups, required this.currentStoryGroupIndex});

  @override
  List<Object> get props => [story_groups, currentStoryGroupIndex];
}

final class AppFinished extends AppState {}
