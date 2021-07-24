import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/auth/blocs/authentication/authentication_bloc.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';

class PrimaryDrawer extends StatelessWidget {
  const PrimaryDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    return Container(
      color: theme.backgroundColor,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        width: 100,
        height: 40,
        child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(AppLogoutRequested());
            },
            child: Text(
              "Logout",
            )),
      ),
    );
  }
}
