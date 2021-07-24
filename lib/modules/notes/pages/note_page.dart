import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/notes/blocs/add_new_note/add_new_note_cubit.dart';
import 'package:web_todolist/modules/notes/blocs/get_note/get_note_bloc.dart';
import 'package:web_todolist/modules/notes/pages/add_note_page.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';
import 'package:web_todolist/shared/constants.dart';
import 'package:web_todolist/shared/theme.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;

    return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: BlocConsumer<AddNewNoteCubit, AddNewNoteState>(
          listener: (context, state) {
            if (state.loading == FormzStatus.submissionSuccess) {
              if (context.read<AddNewNoteCubit>().mode == NoteMode.add) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Note successfully added!",
                      style: TextStyle(
                        color: Colors.pink,
                      )),
                ));
              }
              context.read<GetNoteBloc>().add(GetNote());
            }
          },
          builder: (context, state) {
            return BlocBuilder<GetNoteBloc, GetNoteState>(
              builder: (context, state) {
                if (state is GetNoteError) {
                  return Center(
                    child: Text("An error occured"),
                  );
                }
                if (state is GetNoteLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<GetNoteBloc>().add(GetNote());
                    },
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _buildSwipeRightWarning(theme),
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.result.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            var firstLett =
                                state.result[index].content.trim().split("");
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewNotePage(
                                      note: state.result[index],
                                    ),
                                  ),
                                );
                              },
                              child: Dismissible(
                                onDismissed: (direction) async {
                                  await FirebaseFirestore.instance
                                      .collection(NOTE_REF)
                                      .doc(state.result[index].id)
                                      .delete()
                                      .then((value) => context
                                          .read<GetNoteBloc>()
                                          .add(GetNote()));
                                },
                                key: UniqueKey(),
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: theme.primaryColor
                                          .withOpacity(0.05)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (firstLett.length > 50
                                                        ? firstLett
                                                            .take(50)
                                                            .join()
                                                        : firstLett.length >
                                                                10
                                                            ? firstLett.join()
                                                            : firstLett.length >
                                                                    0
                                                                ? firstLett
                                                                    .join()
                                                                : "untitled") +
                                                    "...",
                                                style: TextStyle(
                                                    color: theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              DateFormat("dd/MM/yyyy")
                                                  .format(DateTime.parse(state
                                                      .result[index]
                                                      .createdAt))
                                                  .toString(),
                                              style: TextStyle(
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewNotePage(
                                                note: state.result[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: theme.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ));
  }

  Widget _buildSwipeRightWarning(CustomTheme theme) {
    return Center(
      child: Text(
        "swipe right to delete a note",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: theme.primaryColor.withOpacity(0.14),
        ),
      ),
    );
  }
}
