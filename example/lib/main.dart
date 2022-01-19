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
  AnimatedDigitController _controller = AnimatedDigitController(1111);

  double textscaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    textscaleFactor = MediaQuery.textScaleFactorOf(context);
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
    _controller.resetValue(12531.98);
  }

  void updateFontScale() {
    setState(() {
      textscaleFactor = textscaleFactor == 1.0 ? 1.2 : 1.0;
    });
  }

  void _addDecimal() {
    var val = num.parse(Random().nextDouble().toStringAsFixed(2));
    _controller.addValue(val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Animated Digit Widget Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleDigitProvider(
                data: SingleDigitData(
                  formatter: (val) => "Hello $val ~ ",
                ),
                child: AnimatedDigitWidget(
                  value: DateTime.now().year,
                ),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                loop: true,
                duration: Duration(milliseconds: 520),
                curve: Curves.easeOutCubic,
                autoSize: true,
                animateAutoSize: true,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.orange[200], fontSize: 30),
                enableSeparator: true,
                duration: Duration(milliseconds: 520),
                autoSize: true,
                animateAutoSize: true,
                loop: true,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.purple[200], fontSize: 30),
                fractionDigits: 2,
                enableSeparator: true,
                autoSize: true,
                animateAutoSize: true,
                duration: Duration(milliseconds: 520),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                separateLength: 1,
                separateSymbol: "#",
                enableSeparator: true,
                loop: true,
                autoSize: true,
                animateAutoSize: true,
                duration: Duration(milliseconds: 520),
              ),
              SizedBox(height: 20),
              SingleDigitProvider(
                data: SingleDigitData(
                  useTextSize: false,
                  size: Size.fromRadius(15),
                  builder: (size, value, isNumber, child) {
                    return isNumber ? child : FlutterLogo(size: 20);
                  },
                ),
                child: AnimatedDigitWidget(
                  controller: _controller,
                  textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                  separateLength: 1,
                  separateSymbol: "#",
                  enableSeparator: true,
                  loop: true,
                  duration: const Duration(milliseconds: 520),
                ),
              ),
              SizedBox(height: 20),
              SingleDigitProvider(
                data: SingleDigitData(
                  useTextSize: true,
                  builder: (size, value, isNumber, child) {
                    return isNumber ? child : FlutterLogo();
                  },
                ),
                child: AnimatedDigitWidget(
                  controller: _controller,
                  textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                  separateLength: 1,
                  separateSymbol: "#",
                  enableSeparator: true,
                  loop: true,
                  duration: const Duration(milliseconds: 520),
                ),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.cyan[200], fontSize: 30),
                suffix: "& ${DateTime.now().year + 1}",
                duration: const Duration(milliseconds: 520),
                autoSize: true,
                animateAutoSize: true,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.orangeAccent.shade700, fontSize: 30),
                fractionDigits: 2,
                enableSeparator: true,
                separateSymbol: "·",
                separateLength: 3,
                decimalSeparator: ",",
                prefix: "\$",
                suffix: "€",
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
          data:
              MediaQuery.of(context).copyWith(textScaleFactor: textscaleFactor),
          child: home!,
        );
      },
    );
  }
}
