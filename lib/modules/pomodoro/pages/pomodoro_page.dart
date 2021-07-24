import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_todolist/modules/theme/providers/theme_switcher_provider.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({Key key}) : super(key: key);

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final cusCon = CustomTimerController();
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeSwitcherProvider>(context).theme;
    var borderSide =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.pink));
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0,top: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTimer(
                controller: cusCon,
                from: Duration(minutes: 25),
                to: Duration.zero,
                builder: (remaining) {
                  return Text(
                    "${remaining.minutes}:${remaining.seconds}",
                    style: TextStyle(fontSize: 45.0, color: theme.primaryColor),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  style: TextStyle(color: theme.primaryColor),
                  minLines: 15,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "Write your targets here...",
                      alignLabelWithHint: true,
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
                      disabledBorder: borderSide),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () => cusCon.start(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.pink,
                    ),
                    
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.circular(6),
                      
                    )),
                  ),
                  child: Center(
                    child: Text(
                      "START",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () => cusCon.pause(),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            theme.backgroundColor,
                          )),
                          child: Center(
                            child: Text(
                              "Pause",
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () => cusCon.reset(),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            theme.backgroundColor,
                          )),
                          child: Center(
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.pink[300]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
