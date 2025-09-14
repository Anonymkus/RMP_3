import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GestureHomePage(),
    );
  }
}

class GestureHomePage extends StatefulWidget {
  const GestureHomePage({super.key});

  @override
  State<GestureHomePage> createState() => _GestureHomePageState();
}

class _GestureHomePageState extends State<GestureHomePage> {
  int gestureCount = 0;
  String _currentGesture = "Используй жесты";
  Color backgroundColor = Colors.white;
  double _scale = 1.0;
  double _previousScale = 1.0;

  void _detectGesture(String gestureType) {
    gestureCount ++;
    setState(() {
        _currentGesture = gestureType;
    });
  }

  void _onScale() {
    if (_scale > _previousScale) {
      _detectGesture("Увеличение");
    } else if (_scale < _previousScale) {
      _detectGesture("Уменьшение");
    }
  }

  void _onSwipe(DragUpdateDetails details) {
    if (details.delta.dx < -10) {
      setState(() {
        backgroundColor = Colors.blue;
        _currentGesture = "Свайп влево";
      });
    } else if (details.delta.dx > 10) {
      setState(() {
        backgroundColor = Colors.green;
        _currentGesture = "Свайп вправо";
      });
    } else if (details.delta.dy < -10) {
      setState(() {
        backgroundColor = Colors.red;
        _currentGesture = "Свайп вверх";
      });
    } else if (details.delta.dy > 10) {
      setState(() {
        backgroundColor = Colors.yellow;
        _currentGesture = "Свайп вниз";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'Счетчик жестов: $gestureCount',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Text(
                "Текущий жест: $_currentGesture",
                style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child:
            GestureDetector(
              onPanUpdate: (details) => _onSwipe(details),
              onPanEnd: (details) {
                setState(() {
                  gestureCount++;
                });
              },
              onTap: () => _detectGesture("Обычный тап"),
              onLongPress: () => _detectGesture("Долгое нажатие"),
              child: Container(
                color: backgroundColor,
                alignment: Alignment.center,
                child: Text(
                  "Свайп и тапы",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ),
          ),
          Expanded(
            child:
            GestureDetector(
              onScaleStart: (details) {
                _previousScale = _scale;
              },
              onScaleUpdate: (details) => _onScale(),
              onScaleEnd: (details) {
                _previousScale = _scale;
              },
              child: Container(
                color: backgroundColor,
                alignment: Alignment.center,
                child: Text(
                  "Масштабирование",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
