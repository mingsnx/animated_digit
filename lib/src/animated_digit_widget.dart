import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'number_percision.dart';

/// #### 动画数字控制器
///
/// **code:example:**
/// ```
/// AnimatedDigitController controller = AnimatedDigitController(99.99);
/// // 累加一个数值
/// controller.addValue(100);
/// // 重置数值
/// controller.resetValue(99.99);
/// ```
class AnimatedDigitController extends ValueNotifier<num> {
  /// #### 动画数字控制器
  ///
  /// **@initialValue** initial display value
  /// ```
  /// AnimatedDigitController(99.99)
  /// ```
  AnimatedDigitController(num initialValue)
      : assert(initialValue != null, "initialValue is not null"),
        super(initialValue);

  bool _dispose = false;

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  /// #### 累加数字 | add value
  ///
  /// **能保证不丢失精度计算数值**
  ///
  /// ```
  /// AnimatedDigitController controller = AnimatedDigitController(0.1);
  /// controller.addValue(0.2);
  /// print(controller.value) // 0.3
  /// ```
  void addValue(num newValue) {
    assert(newValue != null, "addValue => newValue is not null");
    if (!_dispose) {
      value = NP.plus(value, newValue);
    }
  }

  /// #### 重置数字 | reset value
  ///
  /// ```
  /// AnimatedDigitController controller = AnimatedDigitController(99.99);
  ///
  /// controller.addValue(0.01);
  /// print(controller.value) // 100
  ///
  /// controller.resetValue(99.99);
  /// print(controller.value) // 99.99
  /// ```
  void resetValue(num newValue) {
    assert(newValue != null, "resetValue => newValue is not null");
    if (!_dispose) {
      value = newValue;
    }
  }
}

/// 动画数字 Widget
///
///
/// ```
/// // 声明控制器
/// AnimatedDigitController _controller = AnimatedDigitController(99.99);
///
/// // build widget
/// AnimatedDigitWidget(
///   controller: _controller,
///   textStyle: TextStyle(color: Color(0xff009668)),
///   fractionDigits: 2, // 带两位小数
///   enableDigitSplit: true, // 启用千位数字分隔符
/// )
///
/// ```
///
class AnimatedDigitWidget extends StatefulWidget {
  /// 数字控制器
  final AnimatedDigitController controller;

  /// 数字字体样式
  final TextStyle textStyle;

  /// 等同于 Container BoxDecoration 的用法
  final BoxDecoration boxDecoration;

  /// 小数位(1000520.987)
  /// `<= 0` => 1000520;
  /// `1` => 1000520.9;
  /// `2` => 1000520.98;
  /// `3` => 1000520.987;
  /// `...` => 1000520.[...];
  final int fractionDigits;

  /// 启用数字分隔符 `1000520.99` | `1,000,520.99`
  final bool enableDigitSplit;

  /// 数字千分位分隔符号, [`enableDigitSplit` = `false`]时无效
  ///
  /// `,` => `1,000,520.99`
  ///
  /// `'` => `1'000'520.99`
  ///
  /// `-` => `1-000-520.99`
  ///
  final String digitSplitNumber;

  /// build AnimatedDigitWidget
  const AnimatedDigitWidget({
    Key key,
    @required this.controller,
    this.textStyle,
    this.boxDecoration,
    this.fractionDigits = 0,
    this.enableDigitSplit = false,
    this.digitSplitNumber = ",",
  })  : assert(controller != null, "must set controller and is not null"),
        assert(enableDigitSplit != null, "enableDigitSplit is not null"),
        super(key: key);

  @override
  _AnimatedDigitWidgetState createState() {
    return _AnimatedDigitWidgetState();
  }
}

class _AnimatedDigitWidgetState extends State<AnimatedDigitWidget> {
  final List<_AnimatedSingleWidget> widgets = [];

  String _oldValue;

  num _value;

  /// value get,
  num get value => _value;

  /// value set
  set value(num newValue) {
    _oldValue = _getValueAsString();
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

  String _getValueAsString() {
    final _val = (_value ?? 0.0).toString();
    return widget.enableDigitSplit
        ? _formatNum(_val, fractionDigits: widget.fractionDigits ?? 0)
        : _val;
  }

  void _onListenChangeValue() {
    value = widget.controller.value;
  }

  String _formatNum(String numstr, {int fractionDigits: 2}) {
    String result;
    if (numstr != null) {
      final List<String> numString = double.parse(numstr).toString().split('.');
      if (!widget.enableDigitSplit && fractionDigits < 1) {
        return numString.first;
      }
      final List<String> digitList = List.from(numString.first.characters);
      if (widget.enableDigitSplit) {
        int len = digitList.length - 1;
        for (int index = 0, i = len; i >= 0; index++, i--) {
          if (index % 3 == 0 && i != len)
            digitList[i] = digitList[i] + (widget.digitSplitNumber ?? "");
        }
      }
      if (fractionDigits > 0) {
        List<String> fractionList = List.from(numString.last.characters);
        if (fractionList.length > fractionDigits) {
          fractionList =
              fractionList.take(fractionDigits).toList(growable: false);
        }
        result =
            '${digitList.join('')}.${fractionList.join('').padRight(fractionDigits, "0")}';
      } else {
        result = digitList.join('');
      }
    } else {
      result = fractionDigits <= 0 ? "0" : "0.".padRight(fractionDigits, "0");
    }
    return result;
  }

  @override
  void didUpdateWidget(AnimatedDigitWidget oldWidget) {
    widget.controller.removeListener(_onListenChangeValue);
    super.didUpdateWidget(oldWidget);
    widget.controller.addListener(_onListenChangeValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onListenChangeValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newValue = _getValueAsString();
    if (newValue.length == widgets.length) {
      for (var i = 0; i < newValue.length; i++) {
        if (i < _oldValue.length) {
          final String old = _oldValue[i];
          final String curr = newValue[i];
          if (old != curr) {
            _setValue(widgets[i].key, curr);
          }
        }
      }
    } else {
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

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }

  void _setValue(Key _aswsKey, String value) {
    (_aswsKey as GlobalKey<__AnimatedSingleWidgetState>)
        .currentState
        .setValue(value);
  }

  void _addAnimatedSingleWidget(String value) {
    widgets.add(_AnimatedSingleWidget(
      initialValue: value,
      textStyle: widget.textStyle,
      boxDecoration: widget.boxDecoration,
    ));
  }
}

class _AnimatedSingleWidget extends StatefulWidget {
  final TextStyle textStyle;
  final BoxDecoration boxDecoration;
  final String initialValue;

  _AnimatedSingleWidget({this.boxDecoration, this.textStyle, this.initialValue})
      : super(key: GlobalKey<__AnimatedSingleWidgetState>());

  @override
  State<StatefulWidget> createState() {
    return __AnimatedSingleWidgetState();
  }
}

class __AnimatedSingleWidgetState extends State<_AnimatedSingleWidget> {
  TextStyle get _textStyle =>
      widget.textStyle ?? const TextStyle(color: Colors.black, fontSize: 25);
  BoxDecoration get _boxDecoration => widget.boxDecoration;

  /// 数字的文本尺寸大小
  Size digitSize;

  String _currentValue;

  /// currentValue get
  String get currentValue => _currentValue;

  /// currentValue set
  set currentValue(String val) {
    _currentValue = val;
    _checkValue();
    _init();
  }

  /// 数字滚动控制
  ScrollController scrollController;

  /// 是否为非数字的符号
  bool get isNumber => _isNumber;
  bool _isNumber;

  @override
  void initState() {
    currentValue = widget.initialValue;
    digitSize = _getPlaceholderSize(_textStyle, isNumber ? "0" : currentValue);
    super.initState();
    _init();
  }

  /// 设置一个新的值
  void setValue(String newValue) {
    _setValue(newValue);
  }

  void _init() {
    if (isNumber) {
      scrollController = ScrollController();
      _animateTo();
    }
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  void _checkValue() {
    _isNumber = int.tryParse(currentValue) != null;
  }

  void _setValue(String newValue) {
    this.currentValue = newValue;
    _checkValue();
    _animateTo();
  }

  void _animateTo() {
    if (isNumber) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (scrollController.hasClients) {
          scrollController.animateTo(int.parse(currentValue) * digitSize.height,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        width: digitSize.width,
        height: digitSize.height,
        decoration: _boxDecoration,
        child: _build(),
      ),
    );
  }

  Widget _build() {
    if (isNumber) {
      return ListView(
        controller: scrollController,
        padding: EdgeInsets.zero,
        children:
            List<Widget>.generate(10, (index) => _buildStaticWidget("$index")),
      );
    }
    return _buildStaticWidget(currentValue);
  }

  Widget _buildStaticWidget(String val) {
    return SizedBox.fromSize(
      size: digitSize,
      child: Center(child: Text(val, style: _textStyle)),
    );
  }
}

Size _getPlaceholderSize(TextStyle _textStyle, String text) {
  TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: _textStyle));
  painter.layout();
  return painter.size;
}
