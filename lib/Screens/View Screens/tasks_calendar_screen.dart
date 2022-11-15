import 'package:expacto_patronam/Models/event.dart';
import 'package:expacto_patronam/Models/event_data_source.dart';
import 'package:expacto_patronam/Provider/event_provider.dart';
import 'package:expacto_patronam/Screens/View%20Screens/event_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWiget extends StatefulWidget {
  const TasksWiget({Key? key}) : super(key: key);

  @override
  State<TasksWiget> createState() => _TasksWigetState();
}

class _TasksWigetState extends State<TasksWiget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventOfSelectedDate;
    if(selectedEvents.isEmpty){
      return Center(
        child: Text("No event found!",style: TextStyle(color: Colors.black,fontSize: 25),),
      );
    }else{
      return SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details){
          if(details.appointments==null){
            return;
          }
          EventModel event = details.appointments!.first;

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> EventViewScreen(event: event))
          );
        },
      );
    }
    return Container();
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details
      ) {
    EventModel event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.backGroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),

      ),
      child: Center(
        child:  Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}
