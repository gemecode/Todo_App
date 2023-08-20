import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/custom_widgets.dart';
import 'package:todo_app/controllers/cubit.dart';
import 'package:todo_app/controllers/states.dart';

class DoneTaskPage extends StatelessWidget {
  const DoneTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return customTaskItemList(tasks);
        }
    );
  }
}
