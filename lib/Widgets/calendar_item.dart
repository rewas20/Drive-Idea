import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Models/event_data_source.dart';
import '../Provider/event_provider.dart';
import '../Screens/View Screens/tasks_calendar_screen.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialDisplayDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      showNavigationArrow: true,
      showDatePickerButton: true,
      onLongPress: (details){
        final provider = Provider.of<EventProvider>(context,listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(context: context,
            builder: (context){
              return const TasksWiget();
            }
        );
      },
    );
  }
}
