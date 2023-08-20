import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/controllers/cubit.dart';
import 'package:todo_app/controllers/states.dart';



class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(title: Text(cubit.labels[cubit.currentIndex])),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "New"),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: "Archive"),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.pages[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (cubit.fromKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: cubit.titleController.text,
                        date: cubit.dateController.text,
                        time: cubit.timeController.text);
                  }
                } else {
                  cubit.scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: cubit.fromKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  controller: cubit.titleController,
                                  type: TextInputType.text,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return ("title must not be empty");
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                  controller: cubit.timeController,
                                  type: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return ("time must not be empty");
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      cubit.timeController.text = value!.format(context).toString();
                                    });
                                  },
                                  label: 'Task time',
                                  prefix: Icons.watch_later_outlined),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultFormField(
                                  controller: cubit.dateController,
                                  type: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return ("date must not be empty");
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2030-12-31'))
                                        .then((value) {
                                      cubit.dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  label: 'Task date',
                                  prefix: Icons.calendar_month_outlined),
                            ],
                          ),
                        ),
                      ),
                    elevation: 20,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });

                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                }
              },
              child: Icon(cubit.fabIcon),
            ),
          );
        },
      ),
    );
  }



}