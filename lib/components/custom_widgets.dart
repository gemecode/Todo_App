import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/controllers/cubit.dart';



Widget customTaskItem(Map tasksModel, context) => Dismissible(
  key: Key(tasksModel['id'].toString()),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(id: tasksModel['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [

        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.deepPurple,
          child: Text(
            "${tasksModel['time']}",
            style: const TextStyle(
                color: Colors.white
            ),
          ),
        ),

        const SizedBox(width: 20,),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "${tasksModel['title']}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),

              Text(
                "${tasksModel['date']}",
                style: const TextStyle(
                  color: Colors.grey,
                  // fontWeight: FontWeight.bold,
                  // fontSize: 18
                ),
              ),

            ],
          ),
        ),

        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(
                  status: "done",
                  id: tasksModel['id']
              );
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            )
        ),

        const SizedBox(width: 20,),

        IconButton(
            onPressed: (){
              AppCubit.get(context).updateData(
                  status: "archive",
                  id: tasksModel['id']
              );
            },
            icon: const Icon(
              Icons.archive,
              color: Colors.black45,
            )
        ),

        const SizedBox(width: 20,),

      ],
    ),
  ),
);

Widget customTaskItemList(List<Map> tasks) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  fallback: (context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          color: Colors.grey,
          size: 200,
        ),
        Text(
          "No tasks yet, please add some tasks",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 18
          ),
        )
      ],
    ),
  ),
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => customTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 20),
        child: Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length
  ),
);