import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/components.dart';
import '../../components/constants.dart';
import '../../cubit/cubit.dart';
import '../../cubit/status.dart';

class ArchivedTasksScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStatus>(
      listener: (context,state){},
      builder: (context,state){
        var tasksList=TodoCubit.get(context).archiveTasksList;
        return buildScreans(tasksList);
      },
    );
  }
}