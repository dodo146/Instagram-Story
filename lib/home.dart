// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story/bloc/app_bloc.dart';
import 'package:instagram_story/bloc/story_bloc.dart';
import 'package:instagram_story/models/study_group.dart';
import 'package:instagram_story/story.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static List<StoryGroup> Story_groups = [];

  void _getStories() {
    Story_groups = StoryGroup.getStories();
  }

  @override
  Widget build(BuildContext context) {
    _getStories();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: appBar(),
        body: StoryGroupDesign());
  }

  Column StoryGroupDesign() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 100,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 10,
            ),
            itemCount: Story_groups.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "btn$index",
                      shape: CircleBorder(eccentricity: 1.0),
                      onPressed: () {
                        context.read<AppBloc>().add(StoryGroupPressed(index));
                        context.read<StoryBloc>().add(LoadStory());
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          return StoryPage(
                            index: index,
                          );
                        })));
                      },
                      child: CircleAvatar(
                        radius: 30,
                        child: Story_groups[index].icon,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        Story_groups[index].name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.amberAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Divider(
          thickness: 3,
          color: Colors.white,
          height: 2,
        )
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "Wishtagram",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }
}
