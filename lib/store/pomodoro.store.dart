import 'dart:async';

import 'package:mobx/mobx.dart';

part 'pomodoro.store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

enum TypeInterval { work, rest }

abstract class _PomodoroStore with Store {
  @observable
  bool started = false;

  @observable
  int minutes = 2;

  @observable
  int seconds = 0;

  @observable
  int timeWork = 2;

  @observable
  int timeToRest = 1;

  @observable
  TypeInterval typeInterval = TypeInterval.work;

  Timer? cronometer;

  @action
  void start() {
    started = true;
    cronometer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (minutes == 0 && seconds == 0) {
        _changeTypeInterval();
      } else if (seconds == 0) {
        seconds = 59;
        minutes--;
      } else {
        seconds--;
      }
    });
  }

  @action
  void stop() {
    started = false;
    cronometer?.cancel();
  }

  @action
  void restart() {
    stop();
    minutes = isWorking() ? timeWork : timeToRest;
    seconds = 0;
  }

  @action
  void incrementTimeWork() {
    timeWork++;
    if (isWorking()) {
      restart();
    }
  }

  @action
  void decrementTimeWork() {
    if (timeWork > 1) {
      timeWork--;
      if (isWorking()) {
        restart();
      }
    }
  }

  @action
  void incrementTimeToRest() {
    timeToRest++;
    if (isResting()) {
      restart();
    }
  }

  @action
  void decrementTimeToRest() {
    if (timeToRest > 1) {
      timeToRest--;
      if (isResting()) {
        restart();
      }
    }
  }

  bool isWorking() {
    return typeInterval == TypeInterval.work;
  }

  bool isResting() {
    return typeInterval == TypeInterval.rest;
  }

  void _changeTypeInterval() {
    if (isWorking()) {
      typeInterval = TypeInterval.rest;
      minutes = timeToRest;
    } else {
      typeInterval = TypeInterval.work;
      minutes = timeWork;
    }
    seconds = 0;
  }
}
