

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedDigitController extends ValueNotifier<num>{
  AnimatedDigitController(num initialValue) : super(initialValue);
  
  bool _dispose = false;

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  void addValue(num newValue){
    if (!_dispose) {
      value += newValue;
    }
  }

  void resetValue(num newValue){
    if (!_dispose) {
      value = newValue;
    }
  }
} 

class AnimatedDigitWidget extends StatefulWidget {

  final AnimatedDigitController controller;
  final TextStyle textStyle;
  final BoxDecoration boxDecoration;
  
  // 小数位
  final int fractionDigits;
  // 启用数字分隔符
  final bool enableDigitSplit;
  // 数字分隔符号
  final String digitSplitSymbol;

  AnimatedDigitWidget({
    Key key, 
    this.textStyle, 
    this.controller, 
    this.boxDecoration, 
    this.fractionDigits = 0,
    this.enableDigitSplit = false,
    this.digitSplitSymbol = ",",
  }): super(key: key);

  @override
  _AnimatedDigitWidgetState createState() {
    return _AnimatedDigitWidgetState();
  } 
}

class _AnimatedDigitWidgetState extends State<AnimatedDigitWidget> {

  final List<_AnimatedSingleWidget> widgets = [];

  num _value;
  String _oldValue;
  num get value => _value;
  set value(num newValue) {
    _oldValue = value.toString();
    _value = newValue;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() { 
    super.initState();
    widget.controller.addListener(_onListenChangeValue);
    value = widget.controller.value;
  }

  String _getValueAsString(){
    final _val = (_value ?? 0.0).toString();
    return widget.enableDigitSplit ? _formatNum(_val, fractionDigits: widget.fractionDigits) : _val;
  } 

  void _onListenChangeValue(){
    value = widget.controller.value;
  }

  String _formatNum(num, {int fractionDigits: 2}) {
    String result;
    if (num != null) {
      final List<String> numString = double.parse(num.toString()).toString().split('.');
      final List<String> digitList = List.from(numString.first.characters);
      List<String> fractionList = List.from(numString.last.characters);
      int len = digitList.length - 1;
      for (int index = 0, i = len; i >= 0; index++, i--) {
        if (index % 3 == 0 && i != len) digitList[i] = digitList[i] + (widget.digitSplitSymbol ?? ",");
      }
      if (fractionDigits > 0){
        if (fractionList.length > fractionDigits) {
          fractionList = fractionList.take(fractionDigits).toList(growable: false);
        }
        result =  '${digitList.join('')}.${fractionList.join('').padRight(fractionDigits, "0")}';
      }
      else{
        result =  digitList.join('');
      }
    } else {
      result = fractionDigits <= 0 ? "0" : "0.".padRight(fractionDigits,"0");
    }
    return result;
  }

  @override
  void dispose() { 
    widget.controller.removeListener(_onListenChangeValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newValue = _getValueAsString();
    if (newValue.length == widgets.length ) {
      for (var i = 0; i < newValue.length; i++) {
        if (i < _oldValue.length) {
          final old = _oldValue[i];
          final curr = newValue[i];
          if (old != curr) {
            _setValue(widgets[i].key, curr);
          }
        }
      }
    }
    else{
      widgets.clear();
      for (var i = 0; i < newValue.length; i++) {
        var initialDigit = newValue[i]; 
        if (i < _oldValue.length) {
          final String old = _oldValue[i];
          final String curr = newValue[i];
          initialDigit = old != curr ? curr : old;
        }
        _addAnimatedSingleWidget(initialDigit);
      }
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets
    );
    
  }

  void _setValue(Key _aswsKey, String value){
    (_aswsKey as GlobalKey<__AnimatedSingleWidgetState>).currentState.setValue(value);
  }

  void _addAnimatedSingleWidget(String value){
    widgets.add(
      _AnimatedSingleWidget(
        initialValue: value, 
        textStyle: widget.textStyle, 
        boxDecoration: widget.boxDecoration,
      )
    );
  }
}

class _AnimatedSingleWidget extends StatefulWidget {
  final TextStyle textStyle;
  final BoxDecoration boxDecoration;
  final String initialValue;

  _AnimatedSingleWidget({ 
    this.boxDecoration: const BoxDecoration(color: Colors.black), 
    this.textStyle: const TextStyle(color: Colors.grey, fontSize: 30),
    this.initialValue: "0"
  }): super(key: GlobalKey<__AnimatedSingleWidgetState>());
  
  @override
  State<StatefulWidget> createState() {
    return __AnimatedSingleWidgetState();
  }
}

class __AnimatedSingleWidgetState extends State<_AnimatedSingleWidget> {

  TextStyle get _textStyle => widget.textStyle;
  BoxDecoration get _boxDecoration => widget.boxDecoration;

  Size digitSize;
  String currentValue;

  ScrollController scrollController = ScrollController();

  bool get isSymbol => int.tryParse(currentValue) == null;

  @override
  void initState() {
    currentValue = widget.initialValue;
    digitSize = _getPlaceholderSize(_textStyle);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animateTo();
    });
  }

  void setValue(String newValue) {
    _setValue(newValue);
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  _setValue(String newValue) {
    this.currentValue = newValue;
    _animateTo();
  }

  void _animateTo() {
    if (!isSymbol) {
      scrollController.animateTo(
        int.parse(currentValue) * digitSize.height, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        width: digitSize.width, height: digitSize.height,
        decoration: _boxDecoration,
        child: _build(),
      ),
    );
  }

  Widget _build(){
    if (isSymbol) {
      return _buildStaticWidget(currentValue);
    }
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: List<Widget>.generate(10, (index) => _buildStaticWidget("$index")),
    );
  }

  Widget _buildStaticWidget(String val){
    return SizedBox.fromSize(
      size: digitSize,
      child: Center(child: Text(val, style: _textStyle)),
    );
  }

}

Size _getPlaceholderSize(TextStyle _textStyle) {
  TextPainter painter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: "0",
      style: _textStyle
    )
  );
  painter.layout();
  return painter.size;
}
