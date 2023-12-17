// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoryGroup extends Equatable {
  List<String> stories;
  Icon icon;
  String name;

  StoryGroup({
    required this.stories,
    required this.icon,
    required this.name,
  });

  static List<StoryGroup> getStories() {
    List<StoryGroup> stories = [];
    stories.add(StoryGroup(
      stories: [
        "assets/images/grandma.jpg",
        "assets/images/dog_image.jpeg",
        "assets/images/lol.jpg"
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Doğukan",
    ));

    stories.add(StoryGroup(
      stories: [
        "assets/images/cat_caviar.jpg",
        "assets/images/gorilla.jpg",
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Hasan",
    ));
    stories.add(StoryGroup(
      stories: [
        "assets/images/harold.jpg",
        "assets/images/Girl-Stock.jpeg",
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Ozan",
    ));
    stories.add(StoryGroup(
      stories: [
        "assets/images/image1.jpeg",
        "assets/images/technology.jpg",
      ],
      icon: Icon(
        Icons.girl,
        size: 35,
      ),
      name: "İdil",
    ));
    stories.add(StoryGroup(
      stories: [
        "assets/images/grandma.jpg",
        "assets/images/dog_image.jpeg",
        "assets/images/lol.jpg",
      ],
      icon: Icon(
        Icons.boy,
        size: 35,
      ),
      name: "Yiğit",
    ));
    return stories;
  }

  @override
  List<Object> get props => [stories, icon, name];
}
