import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSwitchNightMode();
  }

  Widget _buildSwitchNightMode() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 60,
      height: 60,
      child: HoverCursor(
        cursor: Cursor.pointer,

        child: Consumer<ThemeSwitcherProvider>(
          builder: (context, value, child) => InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (!value.loading) {
                if (value.theme.isNight) {
                  print('day');
                  value.changeFlareAnimation("switch_day");
                  value.isLoading(true);
                  value.toggleTheme(true);

                  Future.delayed(Duration(milliseconds: 400), () {
                    value.changeFlareAnimation("day_idle");
                    value.isLoading(false);
                  });
                } else {
                  print('day');
                  value.changeFlareAnimation("switch_night");
                  value.isLoading(true);
                  value.toggleTheme(false);

                  Future.delayed(Duration(milliseconds: 400), () {
                    value.changeFlareAnimation("night_idle");
                    value.isLoading(false);
                  });
                }
              }
            },
            child: FlareActor(
              "assets/flares/switch_daytime.flr",
              fit: BoxFit.contain,
              artboard: "Artboard",
              animation: value.currentAnimation,
              shouldClip: true,
            ),
            // child: Switch(
            //     value: value.theme.isNight,
            //     onChanged: (v) {
            //       if (value.theme.isNight) {
            //         value.toggleTheme(false);
            //       } else
            //         value.toggleTheme(true);
            //     },
            //   )),
          ),
        ),
      ),
    );
  }
}
