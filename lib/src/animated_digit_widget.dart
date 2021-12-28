import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'number_percision.dart';

typedef String FormatValue(String value);

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
  AnimatedDigitController(num initialValue) : super(initialValue);

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
    if (!_dispose) {
      value = NPms.plus(value, newValue);
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
    if (!_dispose) {
      value = newValue;
    }
  }
}

/// 动画数字 Widget
///
///
/// ```
/// 1.
/// - - - - - - - - - - - - - - - - -
/// // easy
/// AnimatedDigitWidget(value: 1314)
/// - - - - - - - - - - - - - - - - -
///
/// 2.
/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/// ```
///
class AnimatedDigitWidget extends StatefulWidget {
  /// 数字控制器 | digit controller
  ///
  /// when the [controller] exists, the [value] will not take effect
  final AnimatedDigitController? controller;

  /// 动画的数字，当没有 [controller] 时生效，用于不需要额外控制数字时，同时存在时，[controller] 具有更高的优先级
  ///
  /// Effective when there is no [controller], used when no additional control digits are needed
  /// [controller] has higher priority
  final num? value;

  /// 数字字体样式 | digit text style
  ///
  /// see [TextStyle]
  final TextStyle? textStyle;

  /// 动画时间 | animate duration
  ///
  /// see [Duration]
  final Duration? duration;

  /// 等同于 Container BoxDecoration 的用法
  ///
  /// see [BoxDecoration]
  final BoxDecoration? boxDecoration;

  /// 小数位(1000520.987)
  ///
  /// `<= 0` => 1000520;
  ///
  /// `1` => 1000520.9;
  ///
  /// `2` => 1000520.98;
  ///
  /// `3` => 1000520.987;
  ///
  /// `...` => 1000520.[...];
  final int? fractionDigits;

  /// 启用数字分隔符 `1000520.99` | `1,000,520.99`
  ///
  /// enable number separator
  final bool enableDigitSplit;

  /// Default thousands separator [`enableDigitSplit` = `false`] invalid,
  /// Other digits can be used `separatorDigits`,
  ///
  /// assert [separatorDigits] at least greater than or equal to 1
  ///
  /// 数字千分位分隔符号, [`enableDigitSplit` = `false`]时无效,
  /// 其他位数可以使用 `separatorDigits`，
  ///
  /// 断言 [separatorDigits] 最小不能低于 1，可以等于
  ///
  /// `,` => `1,000,520.99`
  ///
  /// `'` => `1'000'520.99`
  ///
  /// `-` => `1-000-520.99`
  ///
  final String? digitSplitSymbol;

  /// Separator digits, the default is thousands separator and at least greater than or equal to 1
  ///
  /// 数字分隔位数, 默认为千分位
  ///
  final int separatorDigits;

  /// Insert a symbol between the integer part and the fractional part.
  final String decimalSeparator;

  /// The text to display after the counter.
  final String suffix;

  /// 自定义格式化
  ///
  /// custom format
  ///
  /// ```dart
  /// AnimatedDigitWidget(
  ///   value: 2021,
  ///   formatter: (val) => "Hello ~ $val",
  /// ),
  /// // => Hello ~ 2021
  /// ```
  final FormatValue? formatter;

  /// see [AnimatedDigitWidget]
  AnimatedDigitWidget({
    Key? key,
    this.controller,
    this.value,
    this.textStyle,
    this.duration,
    this.boxDecoration,
    this.fractionDigits = 0,
    this.enableDigitSplit = false,
    this.digitSplitSymbol = ",",
    this.separatorDigits = 3,
    this.decimalSeparator = '.',
    this.suffix = '',
    this.formatter,
  })  : assert(separatorDigits >= 1,
            "@separatorDigits at least greater than or equal to 1"),
        assert(!(value == null && controller == null),
            "the @value & @controller cannot be null at the same time"),
        super(key: key);

  @override
  _AnimatedDigitWidgetState createState() {
    return _AnimatedDigitWidgetState();
  }
}

class _AnimatedDigitWidgetState extends State<AnimatedDigitWidget>
    with WidgetsBindingObserver {
  /// the controller value or widget value
  num get currentValue => widget.controller?.value ?? widget.value!;

  final List<_AnimatedSingleWidget> _widgets = [];

  String _oldValue = "0.0";
  num _value = 0.0;

  /// value get,
  num get value => _value;

  /// value set
  set value(num newValue) {
    _oldValue = _getFormatValueAsString();
    _value = newValue;
    if (mounted) {
      setState(() {});
    }
  }

  /// is negative number
  bool get isNegativeNumber => _value < 0;

  MediaQueryData? _mediaQueryData;
  bool changeDependencies = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    widget.controller?.addListener(_onListenChangeValue);
    value = currentValue;
  }

  String _getFormatValueAsString() {
    var _val = _value.toString();
    if (widget.enableDigitSplit) {
      _val = _formatNum(_val, fractionDigits: widget.fractionDigits ?? 0);
    }
    if (widget.decimalSeparator != '.') {
      _val = _val.replaceAll('.', widget.decimalSeparator);
    }
    if (widget.suffix.isNotEmpty) {
      _val = "$_val ${widget.suffix}";
    }
    return _handlerCustomFormatter(_val);
  }

  String _handlerCustomFormatter(String val) {
    if (widget.formatter == null) {
      return val;
    }
    return widget.formatter!(val);
  }

  void _onListenChangeValue() {
    value = currentValue;
  }

  void _didChange() {
    _widgets.clear();
    _onListenChangeValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaQueryData = MediaQuery.maybeOf(context);
    changeDependencies = true;
  }

  @override
  void reassemble() {
    super.reassemble();
    changeDependencies = true;
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    _didChange();
  }

  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    _didChange();
  }

  String _formatNum(String numstr, {int fractionDigits: 2}) {
    String result;
    final String _numstr =
        isNegativeNumber ? numstr.replaceFirst("-", "") : numstr;
    final List<String> numString = double.parse(_numstr).toString().split('.');

    if (!widget.enableDigitSplit && fractionDigits < 1) {
      result = numString.first;
    }
    final List<String> digitList = List.from(numString.first.characters);
    if (widget.enableDigitSplit) {
      int len = digitList.length - 1;
      for (int index = 0, i = len; i >= 0; index++, i--) {
        if (index % widget.separatorDigits == 0 && i != len)
          digitList[i] = digitList[i] + (widget.digitSplitSymbol ?? "");
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
    return (isNegativeNumber ? "-" : "") + result;
  }

  @override
  void didUpdateWidget(AnimatedDigitWidget oldWidget) {
    widget.controller?.removeListener(_onListenChangeValue);
    super.didUpdateWidget(oldWidget);
    widget.controller?.addListener(_onListenChangeValue);
    if (widget.controller == null) {
      _onListenChangeValue();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    widget.controller?.removeListener(_onListenChangeValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (changeDependencies) {
      _rebuild();
    } else {
      _updateSingle();
    }
    changeDependencies = false;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: _widgets);
  }

  void _rebuild([String? value]) {
    _widgets.clear();
    String newValue = value ?? _getFormatValueAsString();
    for (var i = 0; i < newValue.length; i++) {
      final initialDigit = newValue[i];
      _addAnimatedSingleWidget(initialDigit);
    }
  }

  void _updateSingle() {
    String newValue = _getFormatValueAsString();
    if (newValue.length != _oldValue.length) {
      return _rebuild(newValue);
    }
    for (var i = 0; i < newValue.length; i++) {
      if (i < _oldValue.length) {
        final String old = _oldValue[i];
        final String curr = newValue[i];
        if (old != curr) {
          _setValue(_widgets[i].key, curr);
        }
      }
    }
  }

  void _setValue(Key? _aswsKey, String value) {
    if (_aswsKey == null) {
      return;
    }
    if (_aswsKey is GlobalKey<__AnimatedSingleWidgetState>) {
      _aswsKey.currentState!.setValue(value);
    }
  }

  void _addAnimatedSingleWidget(String value) {
    _widgets.add(_AnimatedSingleWidget(
      initialValue: value,
      textStyle: widget.textStyle,
      boxDecoration: widget.boxDecoration,
      duration: widget.duration,
      textScaleFactor: _mediaQueryData?.textScaleFactor,
    ));
  }
}

/// single
class _AnimatedSingleWidget extends StatefulWidget {
  /// textStyle
  final TextStyle? textStyle;

  /// duration
  final Duration? duration;

  /// boxDecoration
  final BoxDecoration? boxDecoration;

  /// initialValue
  final String initialValue;

  final double? textScaleFactor;

  _AnimatedSingleWidget({
    this.boxDecoration,
    this.duration,
    this.textStyle,
    required this.initialValue,
    this.textScaleFactor,
  }) : super(key: GlobalKey<__AnimatedSingleWidgetState>());

  @override
  State<StatefulWidget> createState() {
    return __AnimatedSingleWidgetState();
  }
}

class __AnimatedSingleWidgetState extends State<_AnimatedSingleWidget> {
  /// text style
  TextStyle get _textStyle =>
      widget.textStyle ??
      const TextStyle(
        color: Colors.black,
        fontSize: 25,
      );

  /// box decoration
  BoxDecoration? get _boxDecoration => widget.boxDecoration;

  /// scroll duration
  late final Duration _duration =
      widget.duration ?? const Duration(milliseconds: 300);

  /// 数字的文本尺寸大小
  Size digitSize = Size.zero;

  /// private currentValue
  String _currentValue = "0";

  /// currentValue get
  String get currentValue => _currentValue;

  /// currentValue set
  set currentValue(String val) {
    _currentValue = val;
    _checkValue();
  }

  /// check value is number type
  void _checkValue() {
    _isNumber = int.tryParse(_currentValue) != null;
  }

  /// 数字滚动控制
  late final ScrollController scrollController = ScrollController();

  /// 是否为非数字的符号
  bool get isNumber => _isNumber;
  bool _isNumber = true;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    getSize();
    _animateTo();
  }

  /// 获取占位符的 Size
  Size getSize() {
    final placeholder = isNumber ? "0" : currentValue;
    return digitSize = _getPlaceholderSize(_textStyle, placeholder);
  }

  Size _getPlaceholderSize(TextStyle _textStyle, String text) {
    final window = WidgetsBinding.instance?.window ?? ui.window;
    final fontWeight = window.accessibilityFeatures.boldText
        ? FontWeight.bold
        : _textStyle.fontWeight == FontWeight.bold
            ? FontWeight.bold
            : FontWeight.normal;
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: _textStyle.copyWith(fontWeight: fontWeight),
      ),
      textScaleFactor: widget.textScaleFactor ?? window.textScaleFactor,
    );
    painter.layout();
    return painter.size;
  }

  /// 设置一个新的值
  void setValue(String newValue) {
    _setValue(newValue);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _setValue(String newValue) {
    currentValue = newValue;
    _animateTo();
  }

  void _animateTo() {
    if (isNumber) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollAnimateTo();
      });
    }
  }

  void _scrollAnimateTo([bool animate = true]) {
    if (scrollController.hasClients) {
      final value = int.parse(currentValue) * digitSize.height;
      if (animate) {
        scrollController.animateTo(
          value,
          duration: _duration,
          curve: Curves.easeInOut,
        );
      } else {
        scrollController.jumpTo(value);
      }
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
        children: List<Widget>.generate(
          10,
          (index) => _buildStaticWidget("$index"),
        ),
      );
    }
    return _buildStaticWidget(currentValue);
  }

  Widget _buildStaticWidget(String val) {
    return Container(
      child: SizedBox.fromSize(
        size: digitSize,
        child: Center(
          child: Text(val, style: _textStyle),
        ),
      ),
    );
  }
}
