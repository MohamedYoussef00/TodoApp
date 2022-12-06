import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytodo/cubit/cubit.dart';

Widget defultTextFormFeld({
  @required IconData prefixIcon,
  IconData sufixIcon,
  @required String formLable,
  bool isObsecure = false,
  @required TextEditingController textController,
  Function onTab,
  Function validate,
  TextInputType keybordType,
}) =>
    TextFormField(
        obscureText: isObsecure,
        controller: textController,
        onTap: onTab,
        validator: validate,
        keyboardType: keybordType,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Icon(sufixIcon),
          labelText: formLable,
          border: OutlineInputBorder(),
        ));

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.blue[300],
              child: Text(
                '${model['time']}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['data'].toString()}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context).updateInDatabase(model['id'], 'done');
              },
              icon: Icon(Icons.check_circle),
            ),
            IconButton(
                onPressed: () {
                  TodoCubit.get(context)
                      .updateInDatabase(model['id'], 'archive');
                },
                icon: Icon(Icons.archive)),
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.get(context).deleteFromDatabase(model['id']);
      },
    );

Widget buildScreans(
    @required var tasksList
    ) => ConditionalBuilder(
      condition: tasksList.length > 0,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasksList[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        itemCount: tasksList.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'No Taskes Yet, Add New Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
