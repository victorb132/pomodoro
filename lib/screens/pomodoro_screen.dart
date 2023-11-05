import 'package:flutter/material.dart';
import 'package:pomodoro/components/cronometer.dart';
import 'package:pomodoro/components/entry_timer.dart';
import 'package:pomodoro/store/pomodoro.store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PomodoroStore>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: Cronometer(),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Observer(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    EntryTimer(
                      title: 'Trabalho',
                      value: store.timeWork,
                      inc: store.started && store.isWorking()
                          ? null
                          : store.incrementTimeWork,
                      dec: store.started && store.isWorking()
                          ? null
                          : store.decrementTimeWork,
                    ),
                    EntryTimer(
                      title: 'Descanso',
                      value: store.timeToRest,
                      inc: store.started && store.isResting()
                          ? null
                          : store.incrementTimeToRest,
                      dec: store.started && store.isResting()
                          ? null
                          : store.decrementTimeToRest,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
