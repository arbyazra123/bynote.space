import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:web_todolist/modules/main/providers/calendar_provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/get_todo/get_todo_bloc.dart';

class HeaderCalendar extends StatelessWidget {
  const HeaderCalendar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calendar = Provider.of<CalendarProvider>(context);
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TableCalendar(
              // rowHeight: 2,
              onDaySelected: (selectedDay, focusedDay) {
                calendar.changeDate(selectedDay);
                context
                    .read<GetTodoBloc>()
                    .add(GetTodoByDate(date: selectedDay));
              },
              currentDay: calendar.currentDate,
              headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(color: theme.primaryColor),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: theme.primaryColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: theme.primaryColor,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (day.day == DateTime.now().day) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: theme.primaryColor,
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                todayDecoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 1,
                          color: theme.primaryColor.withOpacity(0.15))
                    ]),
                selectedDecoration:
                    BoxDecoration(color: Colors.pink, boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 1,
                      color: theme.primaryColor.withOpacity(0.3))
                ]),
                // isTodayHighlighted: true,
                defaultTextStyle: TextStyle(color: theme.primaryColor),
                weekendTextStyle: TextStyle(color: theme.primaryColor),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle:
                      TextStyle(color: theme.primaryColor.withOpacity(0.5)),
                  weekendStyle:
                      TextStyle(color: theme.primaryColor.withOpacity(0.5))),
              focusedDay: calendar.currentDate,
              firstDay: DateTime.now().subtract(Duration(days: 30)),
              calendarFormat: CalendarFormat.week,
              lastDay: DateTime.now().add(
                Duration(days: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
