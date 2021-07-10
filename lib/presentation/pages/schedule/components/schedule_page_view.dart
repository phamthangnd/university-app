import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';

import 'lesson_card.dart';

class SchedulePageView extends StatefulWidget {
  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  late int _currentWeek;
  late List<DateTime> _currentWeekDays;
  int _currentPage = 0;

  late List<Map<String, String>> _daysData;

  AnimatedContainer dayOfWeekButton(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 55,
      width: 47.5,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: (_daysData[index]['day_of_week'] ?? "") + "\n",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _currentPage == index ? Colors.white : Color(0xFFBCC1CD),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: _daysData[index]['num'],
              style: TextStyle(
                  color: _currentPage == index ? Colors.white : Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // initialize data
    _currentWeek = Calendar.getCurrentWeek();
    _currentWeekDays = Calendar.getDaysInWeek(_currentWeek);
    _daysData = [
      {'day_of_week': 'ПН', 'num': _currentWeekDays[0].day.toString()},
      {'day_of_week': 'ВТ', 'num': _currentWeekDays[1].day.toString()},
      {'day_of_week': 'СР', 'num': _currentWeekDays[2].day.toString()},
      {'day_of_week': 'ЧТ', 'num': _currentWeekDays[3].day.toString()},
      {'day_of_week': 'ПТ', 'num': _currentWeekDays[4].day.toString()},
      {'day_of_week': 'СБ', 'num': _currentWeekDays[5].day.toString()},
    ];
  }

  Widget _getPageViewContent(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Время",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: LightThemeColors.grey400),
            ),
            Padding(padding: EdgeInsets.only(right: 40)),
            Text(
              "Предмет",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: LightThemeColors.grey400),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LessonCard(
              Lesson(
                  timeStart: '09.00',
                  timeEnd: '10:30',
                  name: 'Математический анализ',
                  teacher: 'Зуев А.С.',
                  room: 'А-419',
                  type: 'Практика',
                  weeks: [1, 2, 3]),
            )
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _daysData.length,
              (index) => dayOfWeekButton(index),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.black.withOpacity(0.1)),
        Expanded(
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: 6, // пн-пт
            itemBuilder: (context, index) => _getPageViewContent(context),
          ),
        )
      ],
    );
  }
}
