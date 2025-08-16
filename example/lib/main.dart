import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AnimatedDigitWidgetExample());
}

class AnimatedDigitWidgetExample extends StatefulWidget {
  AnimatedDigitWidgetExample({Key? key}) : super(key: key);

  @override
  _AnimatedDigitWidgetExampleState createState() =>
      _AnimatedDigitWidgetExampleState();
}

class _AnimatedDigitWidgetExampleState extends State<AnimatedDigitWidgetExample>
    with SingleTickerProviderStateMixin {
  AnimatedDigitController _controller = AnimatedDigitController(111.987);

  TextScaler textScaler = TextScaler.noScaling;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textScaler = MediaQuery.textScalerOf(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    _controller.addValue(Random().nextInt(DateTime.now().year + 1));
  }

  void _remove() {
    _controller.minusValue(Random().nextInt(DateTime.now().year));
  }

  void _reset() {
    _controller.resetValue(0);
  }

  void updateFontScale() {
    setState(() {
      textScaler = textScaler == TextScaler.noScaling
          ? TextScaler.linear(1.2)
          : TextScaler.noScaling;
    });
  }

  void _addDecimal() {
    var val = num.parse(Random().nextDouble().toStringAsFixed(2));
    _controller.addValue(val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Animated Digit Widget Example"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (BuildContext context, num value, Widget? child) {
                  return Text(
                    "current value:$value",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  );
                },
              ),
              SizedBox(height: 80),
              AnimatedDigitWidget(
                controller: _controller,
              ),
              SizedBox(height: 30),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.orange, fontSize: 30),
                enableSeparator: true,
              ),
              SizedBox(height: 30),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.pinkAccent, fontSize: 30),
                enableSeparator: true,
                fractionDigits: 1,
              ),
              SizedBox(height: 30),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.cyan, fontSize: 30),
                curve: Curves.easeOutCubic,
                enableSeparator: true,
                fractionDigits: 2,
                valueColors: [
                  ValueColor(
                    condition: () => _controller.value <= 0,
                    color: Colors.red,
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 1999,
                    color: Colors.orange,
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 2999,
                    color: Color.fromARGB(255, 247, 306, 24),
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 3999,
                    color: Colors.green,
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 4999,
                    color: Colors.cyan,
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 5999,
                    color: Colors.blue,
                  ),
                  ValueColor(
                    condition: () => _controller.value >= 6999,
                    color: Colors.purple,
                  ),
                ],
              ),
              SizedBox(height: 30),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 85, 226, 179),
                  fontSize: 30,
                ),
                fractionDigits: 3,
                enableSeparator: true,
                separateSymbol: "·",
                separateLength: 3,
                decimalSeparator: ",",
                prefix: "\$",
                suffix: "€",
              ),
              SizedBox(height: 30),
              Container(
                width: 188,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SingleDigitProvider(
                  data: SingleDigitData(
                    useTextSize: false,
                    builder: (size, value, isNumber, child) {
                      return isNumber ? child : FlutterLogo();
                    },
                  ),
                  child: AnimatedDigitWidget(
                    controller: _controller,
                    textStyle: TextStyle(color: Colors.pink[300], fontSize: 30),
                    separateLength: 1,
                    separateSymbol: "#",
                    enableSeparator: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _add,
              child: Icon(Icons.add),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: updateFontScale,
              child: Icon(Icons.font_download),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: _reset,
              child: Icon(Icons.restart_alt),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: _remove,
              child: Icon(Icons.remove),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: _addDecimal,
              child: Icon(Icons.add_box_outlined),
              tooltip: "add decimal",
            ),
          ],
        ),
      ),
      builder: (context, home) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: home!,
        );
      },
    );
  }
}
