
import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AnimatedDigitWidgetExample());
}


class AnimatedDigitWidgetExample extends StatefulWidget {
  AnimatedDigitWidgetExample({Key key}) : super(key: key);

  @override
  _AnimatedDigitWidgetExampleState createState() => _AnimatedDigitWidgetExampleState();
}

class _AnimatedDigitWidgetExampleState extends State<AnimatedDigitWidgetExample> {

  AnimatedDigitController _controller = AnimatedDigitController(520);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() { 
    _controller.dispose();
    super.dispose();
  }
  
  void _add(){
    _controller.addValue(1314);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Digit Widget Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedDigitWidget(
              controller: _controller,
              textStyle: TextStyle(color: Color(0xff009668)),
              fractionDigits: 2,
              enableDigitSplit: true,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: Icon(Icons.add),
      ),
    );
  }
}