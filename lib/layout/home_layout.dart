import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:intl/intl.dart';
import 'package:mytodo/components/notification_services.dart';
import 'package:mytodo/cubit/cubit.dart';
import 'package:mytodo/cubit/status.dart';
import '../components/components.dart';

class HomeLayout extends StatelessWidget {
  var taskNameController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..creatDataBase(),
      child: BlocConsumer<TodoCubit, TodoStatus>(
          listener: (BuildContext context, TodoStatus state) {},
          builder: (BuildContext context, TodoStatus state) {
            TodoCubit Cubit = TodoCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(Cubit.appBarName[Cubit.currentIndex]),
              ),
              body: ConditionalBuilder(
                condition: state is! GetDatabaseLodingStatus,
                builder: (context) => Cubit.screans[Cubit.currentIndex],
                fallback: (context) =>
                    Center(child: ColoredCircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Cubit.FABIcon),
                onPressed: () {
                  NotificationService().showNotification(1, 'first ', 'hahahahahah ahahahaha ahahahah',context);
                  if (Cubit.bottomSheetIsShown) {
                    if (FormKey.currentState.validate()) {
                      Cubit.inseartInToDatabase(
                        taskNameController.text,
                        taskTimeController.text,
                        taskDateController.text.toString(),
                      );
                      Cubit.changeBottomSheetStatus(false, Icons.edit);
                      // Cubit.bottomSheetIsShown=false;
                      Navigator.pop(context);
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet((context) => Container(
                            color: Colors.grey[200],
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: FormKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defultTextFormFeld(
                                        prefixIcon: Icons.title,
                                        formLable: 'Task Title',
                                        textController: taskNameController,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Task Title Must Not be Empty';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    defultTextFormFeld(
                                        prefixIcon: Icons.watch_later,
                                        formLable: 'Task Time',
                                        textController: taskTimeController,
                                        onTab: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) => taskTimeController
                                              .text = value.format(context));
                                        },
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Task Time Must Not be Empty';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    defultTextFormFeld(
                                        prefixIcon: Icons.date_range,
                                        formLable: 'Task Date',
                                        textController: taskDateController,
                                        onTab: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '2025-10-05'))
                                              .then((value) =>
                                                  taskDateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value));
                                        },
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Data Time Must Not be Empty';
                                          }
                                          return null;
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      Cubit.changeBottomSheetStatus(false, Icons.edit);
                    });
                    Cubit.changeBottomSheetStatus(true, Icons.add);
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.grey[100],
                elevation: 100.0,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived'),
                ],
                currentIndex: TodoCubit.get(context).currentIndex,
                onTap: (index) {
                  TodoCubit.get(context).ChangIndex(index);
                },
              ),
            );
          }),
    );
  }
}
