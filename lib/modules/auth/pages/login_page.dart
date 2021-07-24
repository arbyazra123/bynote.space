import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_todolist/modules/auth/blocs/login/login_cubit.dart';
import 'package:web_todolist/shared/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);
  static Page page() => MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NightTheme().backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bynote",
                    style: TextStyle(
                        fontFamily: "Pacifico", fontSize: 50, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Todo, Notes, and Pomodoro Timer",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<LoginCubit>().logInWithGoogle();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Colors.red[700],
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign in with Google",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          "assets/images/gicon.png",
                          width: 25,
                          height: 25,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text("Anonymous Login"),
                          content: Text(
                            "Anonymous login wont synchronize your data across devices and behave temporary, are you sure?",
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: Text(
                                "No",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoDialogAction(
                              child: Text("Yes"),
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<LoginCubit>().logInAnonymously();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Colors.grey[600],
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign in Anonymously",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
