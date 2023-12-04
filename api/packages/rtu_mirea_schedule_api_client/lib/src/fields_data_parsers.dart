import 'package:collection/collection.dart';
import 'package:rtu_mirea_schedule_api_client/src/campuses.dart';
import 'package:schedule/schedule.dart';

/// Parse teachers names from the description field. The description field
/// looks like this:
/// "Преподаватели:\nБалак Павел Викторович\nМартыненков Борис Вита
/// льевич\n\n".
List<String> parseTeachersFromDescription(String description) {
  final exp = RegExp(
    r'Преподавател(?:и|ь):\s([\wА-Яа-яёЁ\s\-]+)(\n\n|\n$)',
    caseSensitive: false,
    unicode: true,
    multiLine: true,
  );

  final match = exp.firstMatch(description);
  if (match == null) {
    return [];
  }

  final teachers = match.group(1);

  if (teachers == null) {
    return [];
  }

  return teachers.split('\n').map((e) => e.trim()).toList();
}

/// Parse groups names from the description field.
List<String> parseGroupsFromDescription(String description) {
  final exp = RegExp(
    r'Группы:\s([\wА-Яа-яёЁ\d\s\-]+)(\n\n|\n$)',
    multiLine: true,
  );

  final match = exp.firstMatch(description);

  if (match == null) {
    return [];
  }

  final groups = match.group(1);

  if (groups == null) {
    return [];
  }

  return groups.split('\n').map((e) => e.trim()).toList();
}

/// Parse classrooms from the location field.
/// The location field looks like this:
/// "А-110 (МП-1) А-153 (МП-1) Б-304 (МП-1) А-111 (МП-1) А-155 (МП-1)
///  А-112 (МП-1) А-150 (МП-1) А-156 (МП-1) А-157 (МП-1) А-109 (МП-1) Б-308 (М
///  П-1) Б-305 (МП-1) Б-306 (МП-1) Б-307 (МП-1)". First classroom name and
/// second campus short name.
List<Classroom> parseClassroomsFromLocation(String location) {
  final exp = RegExp(
    r'([\wА-Яа-яёЁ\s\-]+)\s\(([\wА-Яа-яёЁ\s\-]+)\)',
    multiLine: true,
  );

  final matches = exp.allMatches(location);

  if (matches.isEmpty) {
    return [];
  }

  return matches
      .map((e) {
        final classroom = e.group(1);
        final campus = e.group(2);

        if (classroom == null) {
          return null;
        }

        final campusObject = campuses.firstWhereOrNull(
          (element) => element.shortName == campus?.trim(),
        );

        if (classroom.contains('Дистанционно')) {
          return const Classroom.online();
        }

        return Classroom(
          name: classroom.trim(),
          campus: campusObject,
        );
      })
      .where((element) => element != null)
      .map((e) => e!)
      .toList();
}

/// The SUMMARY field contains the subject name and the lesson type.
/// First comes the abbreviated lesson type, followed by the name of the item
/// separated by a space.
///
/// For example: "ЛК Информатика" or "СР Ознакомительная практика".
(String, LessonType) parseSubjectAndLessonTypeFromSummary(String summary) {
  final exp = RegExp(
    r'([\wА-Я]+)\s([\wА-Яа-яёЁ\s\-]+)',
  );

  final match = exp.firstMatch(summary);

  if (match == null) {
    return ('', LessonType.unknown);
  }

  final lessonType = match.group(1);
  final subject = match.group(2);

  if (lessonType == null || subject == null) {
    return ('', LessonType.unknown);
  }

  return (subject.trim(), _getLessonTypeByAbbreviation(lessonType.trim()));
}

LessonType _getLessonTypeByAbbreviation(String abbreviation) {
  switch (abbreviation) {
    case 'ЛК':
      return LessonType.lecture;
    case 'ПР':
      return LessonType.practice;
    case 'ЛР':
      return LessonType.laboratoryWork;
    case 'СР':
      return LessonType.individualWork;
    case 'КП':
      return LessonType.courseWork;
    case 'КР':
      return LessonType.courseProject;
    case 'ЭКЗ':
      return LessonType.exam;
    case 'ЗАЧ':
      return LessonType.credit;
    case 'ЛАБ':
      return LessonType.laboratoryWork;

    default:
      return LessonType.unknown;
  }
}
