import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/auth/blocs/authentication/authentication_bloc.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/modules/todo/blocs/add_new_todo/add_new_todo_cubit.dart';
import 'package:web_todolist/modules/todo/models/todo.dart';
import 'package:web_todolist/shared/theme.dart';

class AddNewTodoDialog extends StatefulWidget {
  AddNewTodoDialog({Key key}) : super(key: key);

  @override
  _AddNewTodoDialogState createState() => _AddNewTodoDialogState();
}

class _AddNewTodoDialogState extends State<AddNewTodoDialog> {
  final contentCon = TextEditingController();

  final timeCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var borderSide = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink,
      ),
    );
    return BlocBuilder<AddNewTodoCubit, AddNewTodoState>(
      builder: (context, state) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            return Container(
              color: theme.backgroundColor,
              height: MediaQuery.of(context).size.height * .5,
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(theme, context),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: contentCon,
                        style: TextStyle(color: theme.primaryColor),
                        decoration: InputDecoration(
                          labelText: "Content",
                          hintText: "Write your target",
                          border: borderSide,
                          labelStyle: TextStyle(
                            color: theme.primaryColor.withOpacity(
                              0.7,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: theme.primaryColor.withOpacity(
                              0.2,
                            ),
                          ),
                          focusedBorder: borderSide,
                          enabledBorder: borderSide,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: timeCon,
                        style: TextStyle(color: theme.primaryColor),
                        readOnly: true,
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime.now().add(Duration(days: 365)),
                              onChanged: (date) {
                            print('change ');
                          }, onConfirm: (date) {
                            timeCon.text =
                                DateFormat("EEE, HH:mm").format(date);
                            context.read<AddNewTodoCubit>().onTimeChanged(date);
                          },
                              currentTime: state.time ?? DateTime.now(),
                              locale: LocaleType.en);
                        },
                        decoration: InputDecoration(
                          labelText: "Time",
                          labelStyle: TextStyle(
                            color: theme.primaryColor.withOpacity(
                              0.7,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: theme.primaryColor.withOpacity(
                              0.5,
                            ),
                          ),
                          border: borderSide,
                          focusedBorder: borderSide,
                          enabledBorder: borderSide,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.pink,
                            ),
                            child: Checkbox(
                              value: state.isImportant,
                              onChanged: (v) {
                                context
                                    .read<AddNewTodoCubit>()
                                    .onImprotantChanged(!state.isImportant);
                              },
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(2),
                              //   side:
                              //       BorderSide(color: Colors.white, width: 0.5),
                              // ),
                              checkColor: Colors.white,
                              activeColor: Colors.pink,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Is it important?",
                            style: TextStyle(
                              color: theme.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AddNewTodoCubit>().add(
                                  Todo(
                                    userId: authState.user.id,
                                    content: contentCon.text,
                                    done: false,
                                    time: timeCon.text,
                                    important: false,
                                  ),
                                );

                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "Add new Todo",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Row _buildHeader(CustomTheme theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Add New Todo",
            style: TextStyle(
              color: theme.primaryColor,
            ),
          ),
        ),
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: theme.primaryColor,
            ))
      ],
    );
  }
}
