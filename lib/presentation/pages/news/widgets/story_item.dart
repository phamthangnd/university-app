import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widgets/stories_wrapper.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({Key? key, required this.stories, required this.storyIndex})
      : super(key: key);

  final int storyIndex;
  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(
          StoriesWrapper(
            stories: stories,
            storyIndex: storyIndex,
          ),
        );
      },
      child: Hero(
        tag: stories[storyIndex].title,
        child: Container(
          height: 120,
          width: 88,
          padding: const EdgeInsets.all(8),
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              stories[storyIndex].title,
              style: DarkTextTheme.chip,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  NetworkImage(stories[storyIndex].preview.formats.small.url),
              colorFilter: ColorFilter.mode(
                  DarkThemeColors.background02.withOpacity(0.15),
                  BlendMode.dstOut),
            ),
          ),
        ),
      ),
    );
  }
}
