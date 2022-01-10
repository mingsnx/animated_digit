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

class _AnimatedDigitWidgetExampleState
    extends State<AnimatedDigitWidgetExample> with SingleTickerProviderStateMixin {
  AnimatedDigitController _controller =
      AnimatedDigitController(1111);

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
  
  void _remove(){
    _controller.addValue(-Random().nextInt(DateTime.now().year));
  }

  void _reset() {
    _controller.resetValue(0);
  }

  void updateFontScale() {
    setState(() {
      textscaleFactor = textscaleFactor == 1.0 ? 1.2 : 1.0;
    });
  }

  void _addDecimal(){
    var val = num.parse(Random().nextDouble().toStringAsFixed(2));
    _controller.addValue(val);
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
                value: DateTime.now().year,
                textStyle: TextStyle(color: Colors.red.shade500, fontSize: 25),
                formatter: (val) => "Hello $val ~ ",
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                loop: true,
                duration: Duration(seconds: 1),
                curve: Curves.easeOutCubic,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.orange[200], fontSize: 30),
                enableDigitSplit: true,
                duration: const Duration(milliseconds: 500),
                autoSize: true,
                loop: true,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.purple[200], fontSize: 30),
                fractionDigits: 2,
                enableDigitSplit: true,
                autoSize: true,
                animateAutoSize: true,
                duration: const Duration(milliseconds: 500),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                separatorDigits: 1,
                digitSplitSymbol: "#",
                enableDigitSplit: true,
                loop: true,
                autoSize: true,
                animateAutoSize: true,
                duration: const Duration(seconds: 1),
              ),
              SizedBox(height: 20),
              SingleDigitProvider(
                data: SingleDigitData(
                  useTextSize: false,
                  size: Size.fromRadius(15),
                  builder: (size, value, isNumber, defaultBuilder) {
                    return isNumber ? defaultBuilder() : FlutterLogo(size: 20);
                  },
                ),
                child: AnimatedDigitWidget(
                  controller: _controller,
                  textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                  separatorDigits: 1,
                  digitSplitSymbol: "#",
                  enableDigitSplit: true,
                  loop: true,
                  duration: const Duration(seconds: 1),
                ),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
                separatorDigits: 1,
                digitSplitSymbol: "#",
                enableDigitSplit: true,
                loop: true,
                singleBuilder: (size, value, isNumber, defaultBuilder) {
                  return isNumber ? defaultBuilder() : FlutterLogo();
                },
                duration: const Duration(seconds: 1),
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.cyan[200], fontSize: 30),
                suffix: "& ${DateTime.now().year + 1}",
                duration: const Duration(seconds: 1),
                autoSize: true,
                animateAutoSize: true,
              ),
              SizedBox(height: 20),
              AnimatedDigitWidget(
                controller: _controller,
                textStyle: TextStyle(color: Colors.white, fontSize: 30),
                fractionDigits: 2,
                enableDigitSplit: true,
                digitSplitSymbol: "·",
                separatorDigits: 3,
                decimalSeparator: ".",
                autoSize: true,
                animateAutoSize: true,
                loop: true,
                boxDecoration:
                    BoxDecoration(color: Colors.yellowAccent.shade400),
                formatter: (val) => "\$$val",
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 500),
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
          data: MediaQuery.of(context).copyWith(textScaleFactor: textscaleFactor),
          child: home!,
        );
      },
    );
  }
}
