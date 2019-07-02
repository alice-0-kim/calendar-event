import 'package:flutter/material.dart';

final MONTHS = ['Janunary', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
final DAYS_OF_WEEK = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

int getDaysOfMonth(int month) => month == 2 ? 28 : (month % 2 == 1 && month < 8 || month % 2 == 0 && month > 7 ? 31 : 30);

class Day {
  List<Event> events = [];

  addEvent(event) {
    events.add(event);
  }

  hasEvent() {
    return events.isNotEmpty;
  }

  @override
  toString() {
    return events.toString();
  }
}

class Month {
  Month(this.month) {
    days = List(getDaysOfMonth(month));
    for (int i = 0; i < getDaysOfMonth(month); i++)
      days[i] = Day();
  }

  final int month;
  List<Day> days;

  addEvent(day, event) {
    print('Event added on ${MONTHS[month]} ${day + 1}');
    days[day].addEvent(event);
  }

  hasEvent(day) {
    return days[day].hasEvent();
  }

  @override
  toString() {
    return days.toString();
  }
}

class Year {
  Year() {
    months = MONTHS.map((m) => MONTHS.indexOf(m)).map((i) => Month(i)).toList();
  }
  List<Month> months;

  addEvent(month, day, event) {
    months[month].addEvent(day, event);
  }

  hasEvent(month, day) {
    return months[month].hasEvent(day);
  }
}

class CalendarEvent {
  Year year = Year();

  addEvent(month, day, type, time, hours, desc) {
    year.addEvent(month, day, Event(type, time, hours, desc));
  }

  hasEvent(month, day) {
    return day < 0 || getDaysOfMonth(month) <= day ? false : year.hasEvent(month, day);
  }
}

class Event {
  Event(this.type, this.time, this.hours, this.desc);

  final int type;
  final TimeOfDay time;
  final int hours;
  final String desc;

  @override
  toString() {
    return '$desc at ${time.hour}:${time.minute} for $hours';
  }
}