library calendar_event;

import 'package:flutter/material.dart';
import 'util.dart';

class Calendar extends StatefulWidget {
//  Calendar({Key key, this.year, this.month, this.day, this.daysOfMonth}): super(key: key);
  Calendar({Key key, this.year, this.month, this.day, this.daysOfMonth, this.calendarEvent}): super(key: key);

  static const MONTHS = ['Janunary', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  static const DAYS_OF_WEEK = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  int year, month, day, daysOfMonth;
  CalendarEvent calendarEvent;

  factory Calendar.today() {
    DateTime today = new DateTime.now();
    return Calendar(year: today.year, month: today.month, day: today.day, daysOfMonth: Calendar.getDaysOfMonth(today.month),);
  }

  static int getDaysOfMonth(int month) {
    return month == 2 ? 28 : (month % 2 == 1 && month < 8 || month % 2 == 0 && month > 7 ? 31 : 30);
  }

  addEvent(month, day, type, time, hours, desc) {
    calendarEvent.year.addEvent(this.month - 1, this.day - DateTime(year, this.month).weekday + 1, Event(type, time, hours, desc));
  }

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  @override
  Widget build(BuildContext context) => _buildCalendar(widget.month);

  Widget _buildCalendar(int month) => Column(children: <Widget>[_buildHeader(),_buildEntries()]);

  _isToday(index) {
    return DateTime.now().day + DateTime(2019, DateTime.now().month).weekday - 2 == index && DateTime.now().month == widget.month;
  }

  _isThisMonth(firstDayOfMonth, index) {
    return firstDayOfMonth.weekday - 1 <= index && index < widget.daysOfMonth + firstDayOfMonth.weekday - 1;
  }

  _buildEventIndicator() {
    return Positioned(
      bottom: 10,
      child: Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),),
    );
  }

  _getDateText(int index) {
    DateTime firstDayOfMonth = DateTime(widget.year, widget.month);
    // TODO: Investigate!
    int daysOfLastMonth = Calendar.getDaysOfMonth(widget.month == 0 ? 11 : widget.month - 1);
    if (index < firstDayOfMonth.weekday - 1) return '${daysOfLastMonth - firstDayOfMonth.weekday + index + 2}';
    return index < widget.daysOfMonth + firstDayOfMonth.weekday - 1 ? '${index + 2 - firstDayOfMonth.weekday}' : '${(index + 2 - firstDayOfMonth.weekday) % widget.daysOfMonth}';
  }

  _getDateColor(int index) {
    DateTime firstDayOfMonth = DateTime(widget.year, widget.month);
    return _isToday(index) ? Colors.white : _isThisMonth(firstDayOfMonth, index) ? Colors.black : Colors.black38;
  }

  _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: Calendar.DAYS_OF_WEEK.map((day) =>
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text('${day.substring(0, 1)}', textAlign: TextAlign.center),
            ),
          ),
      ).toList(),
    );
  }

  _buildEntries() {
    return GridView.count(
      crossAxisCount: 7,
      children: List.generate(42, (index) => _buildEntry(index)),
      shrinkWrap: true,
    );
  }

  _buildEntry(index) {
    return GestureDetector(
      onTap: () => setState(() { widget.day = index; }),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.center,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isToday(index) ? Colors.indigo : (index == widget.day ? Colors.indigo[100] : Colors.transparent),
            ),
            padding: EdgeInsets.all(5),
            child: Text(_getDateText(index), style: TextStyle(color: _getDateColor(index)), textAlign: TextAlign.center),
          ),
          if (widget.calendarEvent.hasEvent(widget.month - 1, index - DateTime(widget.year, widget.month).weekday + 1)) _buildEventIndicator(),
        ],
      ),
    );
  }
}
