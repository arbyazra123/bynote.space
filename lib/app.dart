import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:web_todolist/routes.dart';

import 'modules/auth/blocs/authentication/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bynote : Todo,Notes,And Pomodoro Timer',
      theme: ThemeData(
        fontFamily: "VarelaRound",
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AuthenticationBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
