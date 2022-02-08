import 'package:flutter/material.dart';
import 'package:iagenda/event.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then(
    (_) => runApp(MaterialApp(
      home: agenda(),
      debugShowCheckedModeBanner: false,
    )),
  );
}

class agenda extends StatefulWidget {
  //const agenda({Key? key}) : super(key: key);

  @override
  _agendaState createState() => _agendaState();
}

class _agendaState extends State<agenda> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Agenda"),
          backgroundColor: const Color(0xff1F1F62),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TableCalendar(
                        locale: 'pt_BR',
                        focusedDay: _focusedDay,

                        firstDay: DateTime(DateTime.now().day),
                        lastDay: DateTime(2500),
                        calendarFormat: format,
                        onFormatChanged: (CalendarFormat _format) {
                          setState(() {
                            format = _format;
                          });
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        daysOfWeekVisible: true,

                        //Mudança de dia
                        selectedDayPredicate: (DateTime date) {
                          return isSameDay(_selectedDay, date);
                        },
                        onDaySelected: (DateTime selectDay, DateTime focusDay) {
                          setState(() {
                            _selectedDay = selectDay;
                            _focusedDay = focusDay;
                          });
                          print(_focusedDay);
                        },

                        eventLoader: _getEventsfromDay,

                        //Stilo calendario
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          selectedDecoration: BoxDecoration(
                            color: const Color(0xff1F1F62),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          selectedTextStyle:
                              const TextStyle(color: Colors.white),
                          todayDecoration: BoxDecoration(
                            color: const Color(0xff1F1F62),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Tarefas",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _getEventsfromDay(_selectedDay).length,
                          padding: EdgeInsets.only(top: 4),
                          itemBuilder: (context, index) {
                            Event event =
                                _getEventsfromDay(_selectedDay)[index];
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                leading: Container(
                                    alignment: Alignment.bottomLeft,
                                    height: 60,
                                    width: 5,
                                    color: Color(0xffffdb58)),
                                title: Text(event.title),
                                subtitle: const Text(
                                    'Solicitar o desmonte de 10 pallets'),
                                trailing: const Text("09:30"),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Adicionar evento"),
                    content: TextFormField(
                      controller: _eventController,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            if (_eventController.text.isEmpty) {
                            } else {
                              if (selectedEvents[_selectedDay] != null) {
                                selectedEvents[_selectedDay]!.add(
                                  Event(title: _eventController.text),
                                );
                              } else {
                                selectedEvents[_selectedDay] = [
                                  Event(title: _eventController.text)
                                ];
                              }
                            }
                            Navigator.pop(context);
                            _eventController.clear();
                            setState(() {});
                            return;
                          },
                          child: const Text("Ok"))
                    ],
                  )),
          //label: Text(''),
          backgroundColor: const Color(0xff1F1F62),
          child: const Icon(Icons.add),
        ));
  }
}
