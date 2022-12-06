import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytodo/cubit/cubit.dart';
import 'package:mytodo/cubit/status.dart';
import '../../components/components.dart';
import '../../components/constants.dart';

class NewTasksScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStatus>(
      listener: (context,state){},
      builder: (context,state){
        var tasksList=TodoCubit.get(context).newTasksList;
        return buildScreans(tasksList);
      },
    );

  }
}