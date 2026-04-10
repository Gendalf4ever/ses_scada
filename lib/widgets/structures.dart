import 'package:flutter/material.dart';

//global constants
const double screenWidth = 1280;
const double screenHeight = 1024;

//global structs
class BusStateWidget {
  static final Map<int, String> _states = {
    0: 'Шина обесточена',
    1: 'Низк. сопрот. изоляции',
    2: 'Oтклонение частоты или напряжения',
  };

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }
}

class ControlPostWidget {
  static final Map<int, String> _states = {
    -1: 'Не опр. пост',
    0: 'Ошибка чтения',
    1: 'Упр. ШУ СЭС1',
    2: 'Упр. ШУ СЭС2',
    3: 'Упр. с ИСУ ТС',
  };

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }
}

class SesModeStateWidget {
  static final Map<int, String> _states = {
    -1: 'Не опр.',
    0: 'Ошибка чтения',
    1: 'Стоянка',
    2: 'Морской ходовой',
    3: 'Маневренный',
    4: 'ДинПоз',
    5: 'Ручной',
    6: 'Переходный',
  };

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }
}

class PanelIsLocalWidget {
  static final Map<int, String> _states = {0: 'МУ', 1: 'ДУ'};

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }
}

class PanelsListWidget {
  static final Map<int, String> _states = {1: 'SES1', 2: 'SES2'};

  static final List<String> plsList = ['unknown', 'SES1', 'SES2'];

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }

  static List<String> getList(int state) {
    return plsList;
  }
}

class GDGStateWidget {
  static final Map<int, String> _states = {
    -1: 'Не опр.',
    0: 'Ошибка чтения',
    1: 'Включен, не готов к выключению',
    2: 'Выключен, не готов к включению',
    3: 'Авария',
    4: 'Выключен, готов к включению',
    5: 'Включен, готов к выключению',
    6: 'В защите',
    7: 'Включается',
    8: 'Выключается',
    9: 'Предупреждение',
  };

  static final Map<int, Color> _colors = {
    -1: Colors.red,
    0: Colors.yellow,
    1: Colors.blue,
    2: Colors.blue,
    3: Colors.red,
    4: Colors.white,
    5: Colors.green,
    6: Colors.yellow,
    7: Colors.white,
    8: Colors.green,
    9: Colors.yellow,
  };

  static String get(int state) {
    return _states[state] ?? 'invalid state';
  }

  static Color getColor(int state) {
    return _colors[state] ?? Colors.red;
  }

  static Map<int, String> getLabelList() {
    return _states;
  }

  static Map<int, Color> getColorList() {
    return _colors;
  }
}

/*
EXAMPLES OF WIDGETS

class BusStateWidget {
  static final Map<int, Text> _states = {
    0: const Text(
      'Шина обесточена',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.yellow),
    ),
    1: const Text(
      'Низк. сопрот. изоляции',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.yellow),
    ),
    2: const Text(
      'Oтклонение частоты или напряжения',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.yellow),
    ),
  };

  static Text get(int state) {
    return _states[state] ??
        const Text(
          'invalid state',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.red),
        );
  }
}

class BusStateWidget {
  // Pure strings — readable, editable, portable
  static final Map<int, String> _labels = {
    0: 'state 0',
    1: 'state 1',
    2: 'state 2',
  };

  // Independent full UI definitions — one per state
  static final Map<int, Widget Function(String)> _builders = {
    0: (label) => Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.yellow),
        ),
    1: (label) => Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.yellow),
        ),
    2: (label) => Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.yellow),
        ),
  };

  // Public API
  static Widget get(int state) {
    final label = _labels[state];
    final builder = _builders[state];

    if (label == null || builder == null) {
      return const Text(
        'invalid state',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.red),
      );
    }

    return builder(label);
  }
}*/
