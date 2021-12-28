import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/cupertino.dart';
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

class _AnimatedDigitWidgetExampleState
    extends State<AnimatedDigitWidgetExample> {
  AnimatedDigitController _controller = AnimatedDigitController(520);

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
    if (Random().nextBool()) {
      _controller.resetValue(Random().nextInt(1314) + 210);
    } else {
      _controller.resetValue(Random().nextDouble() + 210);
    }
  }

  void updateFontScale() {
    setState(() {
      textscaleFactor = Random().nextDouble() + 1.1;
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _controller.resetValue(_controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Animated Digit Widget Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedDigitWidget(
                value: 1314,
                formatter: (val) => "I Love You $val",
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                fractionDigits: 0,
                separatorDigits: 1,
                digitSplitSymbol: "*",
                enableDigitSplit: true,
                duration: const Duration(seconds: 1),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.orange[200], fontSize: 30),
                fractionDigits: 0,
                enableDigitSplit: true,
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.green, fontSize: 30),
                fractionDigits: 2,
                enableDigitSplit: true,
                digitSplitSymbol: "'",
                separatorDigits: 1,
                decimalSeparator: "-",
                suffix: "[￥]",
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.cyan[200], fontSize: 30),
                fractionDigits: 2,
                enableDigitSplit: true,
                duration: const Duration(seconds: 1),
              )
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
            FloatingActionButton(
              onPressed: updateFontScale,
              child: Icon(Icons.font_download),
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
