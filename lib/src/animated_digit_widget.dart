import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'number_percision.dart';

const TextStyle _$defaultTextStyle =
    TextStyle(color: Colors.black, fontSize: 25);

/// 为了适配flutter 2 中的 `WidgetsBinding.instance` 可能为 `null`
///
/// Adapter `WidgetsBinding.instance` in Flutter 2 may be `null`
class WidgetsBindingx {
  static WidgetsBinding? get instance => WidgetsBinding.instance;
}

/// #### 格式化最终显示的值
///
/// [value] 是默认要显示的结果
///
/// [value] is default display result
///
typedef String FormatValue(String value);

/// #### 自定义每一个 Widget
typedef Widget AnimatedSingleWidgetBuilder(
  Size size,
  String value,
  bool isNumber,
  Widget child,
);

/// #### 当值符合条件时，改变颜色
typedef TextStyle ValueChangeTextStyle(TextStyle style);

/// #### 当值符合条件时，改变颜色
typedef bool ValueColorCondition();

/// #### 用来描述符合条件的 value 字体颜色
///
/// #### the value text color
class ValueColor {
  /// 颜色条件
  ///
  /// the color condition
  ValueColorCondition condition;

  /// text color
  Color color;

  /// #### 用来描述符合条件的 value 字体颜色
  ///
  /// #### the value text color
  ValueColor({
    required this.condition,
    required this.color,
  });
}

/// 单个包装的字符/数字依赖配置数据源
class SingleDigitData {
  /// 单个字符容器尺寸大小。
  /// 如果为 null，则以数字 `0` 为字体宽高标准计算得到。
  ///
  /// The single container size.
  /// If it is null, it will be calculated with the number `0` as the font width and height standard.
  ///
  Size? size;

  /// 根据值变化颜色的集合
  List<ValueColor>? valueColors;

  /// 前缀和后缀跟随颜色变化，默认跟随
  bool prefixAndSuffixFollowValueColor;

  /// 自定义内容 builder
  /// 每一个数字，每一个字符。
  /// 整个 `AnimatedDigitWidget` 由 `value.length` 个 `Single-Widget` 组成，
  /// 所以 `singleBuilder` 就不言而喻了。
  ///
  /// - @size [Size] 其尺寸大小受回调参数中的 `size` 约束，可以通过 [SingleDigitData] 来自定义 `size` 约束。
  /// - @value [String] 参数为当前的 `Single-Widget` 中原本显示的值。
  /// - @isNumber [bool] 用来判断当前的 `Single-Widget` 中的值是否是数字。
  /// - @child [Widget] 默认的 `Single-Widget` 的 build child。
  AnimatedSingleWidgetBuilder? builder;

  /// 是否使用文字本身的 Size 做为包装 Size
  bool useTextSize;

  /// 单个包装的字符/数字依赖配置数据源
  SingleDigitData({
    this.size,
    this.useTextSize = false,
    this.valueColors,
    this.prefixAndSuffixFollowValueColor = true,
    this.builder,
  });

  Widget? _buildChangeTextColorWidget(
    String val,
    TextStyle textStyle, [
    Key? key,
  ]) {
    final vc = _getLastValidValueColor();
    if (vc == null) return null;
    return Text(val, key: key, style: textStyle.copyWith(color: vc.color));
  }

  ValueColor? _getLastValidValueColor() {
    ValueColor? result;
    if (valueColors == null) return null;
    for (var vc in valueColors!) {
      if (vc.condition()) {
        result = vc;
      }
    }
    return result;
  }
}

/// The [SingleDigitData] `DI` provider widget
class SingleDigitProvider extends InheritedWidget {
  /// The [SingleDigitData] `DI` provider widget
  const SingleDigitProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final SingleDigitData data;

  static SingleDigitData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SingleDigitProvider>()!
        .data;
  }

  static SingleDigitData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SingleDigitProvider>()
        ?.data;
  }

  @override
  bool updateShouldNotify(SingleDigitProvider oldWidget) {
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SingleDigitData>('data', data, showName: false));
  }
}

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

  // @override
  // set value(num value) {
  //   super.value = value;
  //   print(value);
  // }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  /// ### 累加数字 | plus value
  ///
  /// **能在不丢失精度计算数值**
  ///
  /// - 为什么需要不丢失精度计算？
  ///
  /// - 因为
  /// ```dart
  /// print(0.1 + 0.2); // => 0.30000000000000004
  /// ```
  /// - 所以 [addValue] 内使用了 [NP.plus]
  /// ```dart
  /// AnimatedDigitController controller = AnimatedDigitController(0.1);
  /// controller.addValue(0.2);
  /// print(controller.value) // => 0.3
  /// ```
  void addValue(num newValue) {
    if (!_dispose) {
      value = NP.plus(value, newValue);
    }
  }

  /// 减 | minus value
  void minusValue(num newValue) {
    if (!_dispose) {
      value = NP.minus(value, newValue);
    }
  }

  /// 乘 | times value
  void timesValue(num newValue) {
    if (!_dispose) {
      value = NP.times(value, newValue);
    }
  }

  /// 除 | divide value
  void divideValue(num newValue) {
    if (!_dispose) {
      value = NP.divide(value, newValue);
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
/// // easy 2
/// AnimatedDigitWidget(
///   value: 1314,
///   loop: true,
///   autoSize: true,
/// )
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
///   enableSeparator: true, // 启用千位数字分隔符
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
  late final TextStyle? _textStyle;

  /// 动画时间 | animate duration
  ///
  /// see [Duration]
  final Duration duration;

  /// 动画曲线 | animate curve
  ///
  /// see [Curve]
  final Curve curve;

  /// 等同于 Container BoxDecoration 的用法
  /// 是对每一个字符生效
  ///
  /// see [BoxDecoration]
  final BoxDecoration? boxDecoration;

  /// 小数位(1000520.987)
  ///
  /// `0` => 1000520;
  ///
  /// `1` => 1000520.9;
  ///
  /// `2` => 1000520.98;
  ///
  /// `3` => 1000520.987;
  ///
  /// `...` => 1000520.[...];
  final int fractionDigits;

  /// ### orgin params => **`enableDigitSplit`** [ `>=v3.1.0` not available]
  ///
  /// 启用数字分隔符 `1000520.99` | `1,000,520.99`
  ///
  /// see [separateLength] and [separateSymbol]
  ///
  /// enable number separator
  final bool enableSeparator;

  /// ### orgin params => **`digitSplitSymbol`** [ `>=v3.1.0` not available]
  ///
  /// Default thousands separator [`enableSeparator` = `false`] invalid,
  /// Other digits can be used `separateLength`,
  ///
  /// assert [separateLength] at least greater than or equal to 1
  ///
  /// 数字千分位分隔符号, [`enableSeparator` = `false`]时无效,
  /// 其他位数可以使用 `separateLength`，
  ///
  /// 断言 [separateLength] 最小不能低于 1，可以等于
  ///
  /// `,` => `1,000,520.99`
  ///
  /// `'` => `1'000'520.99`
  ///
  /// `-` => `1-000-520.99`
  ///
  final String? separateSymbol;

  /// ### orgin params => **`separatorDigits`** [ `>=v3.1.0` not available]
  ///
  /// Separate length, the default is thousands separator and at least greater than or equal to 1
  ///
  /// 数字分隔位数, 默认为千分位(3)
  ///
  final int separateLength;

  /// Insert a symbol between the integer part and the fractional part.
  final String decimalSeparator;

  /// The text to display in front of the counter.
  final String? prefix;

  /// The text to display after the counter.
  final String? suffix;

  /// 数字采用循环滚动。
  ///
  /// - 假设每个数字的 `Box` 高度为 `30`.
  ///
  /// - `false` 时, 从 9 滚动到 => 1 时，中间间隔为 `[0, 1,..., 9]`.
  /// 则是向 **`↑`** 滚动 `9 ~ 1` 之间的距离 `(9 - 1) * 30`,
  ///
  /// - `true` 时, 从 9 滚动到 => 1 时，中间间隔为 `{...9, 0, 1...}`.
  /// 则是向 **`↓`** 滚动 `9 ~ 1` 之间的距离 `(10 - 9 + 1) * 30`
  final bool loop;

  /// 自适应调整 digit/symbol 文本的大小，
  /// 只在未自定义 Size 的情况下有效 `SingleDigitData.size == null`
  ///
  /// digit/symbol adaptive resizing,
  /// Only valid without custom Size `SingleDigitData.size == null`
  final bool autoSize;

  /// 在自适应调整 digit/symbol 文本的大小的时候是否是动画的
  ///
  /// Use animate when digit/symbol text adaptively resizing.
  final bool animateAutoSize;

  /// 根据值变化颜色的集合
  ///
  /// ```dart
  /// int value = 9999; // or use Controller.value
  /// AnimatedDigitWidget(
  ///   value: value,
  ///   textStyle: TextStyle(color: Colors.orange, fontSize: 30),
  ///   valueColors: [
  ///     ValueColor(
  ///       //When value <= 0 , the color changes to red
  ///       condition: () => value <= 0,
  ///       color: Colors.red,
  ///     ),
  ///     // you can add more ...，but always take the last eligible.
  ///   ],
  /// ),
  /// ```
  final List<ValueColor>? valueColors;

  /// see [AnimatedDigitWidget]
  AnimatedDigitWidget({
    Key? key,
    TextStyle? textStyle,
    this.controller,
    this.value,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.boxDecoration,
    this.fractionDigits = 0,
    this.enableSeparator = false,
    this.separateSymbol = ",",
    this.separateLength = 3,
    this.decimalSeparator = '.',
    this.prefix,
    this.suffix,
    this.loop = true,
    this.autoSize = true,
    this.animateAutoSize = true,
    this.valueColors,
  })  : assert(separateLength >= 1,
            "@separateLength at least greater than or equal to 1"),
        assert(!(value == null && controller == null),
            "the @value & @controller cannot be null at the same time"),
        super(key: key) {
    if (textStyle != null) {
      if (textStyle.color == null) {
        _textStyle = textStyle.copyWith(color: Colors.black);
      } else {
        _textStyle = textStyle;
      }
    } else {
      _textStyle = _$defaultTextStyle;
    }
  }

  @override
  _AnimatedDigitWidgetState createState() {
    return _AnimatedDigitWidgetState();
  }
}

class _AnimatedDigitWidgetState extends State<AnimatedDigitWidget>
    with WidgetsBindingObserver {
  /// see [MediaQueryData]
  MediaQueryData? _mediaQueryData;

  /// see [SingleDigitData]
  SingleDigitData? _singleDigitData;

  /// mark dirty, rebuild widget
  ///
  /// 当触发以下回调时
  /// [reassemble],
  /// [didChangeDependencies],
  /// [didChangeTextScaleFactor]
  /// [didChangeAccessibilityFeatures],
  /// 将需要被重建，
  /// 会通过 [_markNeedRebuild] 变更成 `true`，
  ///
  /// 在 [build] 完成时，恢复为 `false`, 以待下次重建
  bool _dirty = false;

  late final TextStyle style = widget._textStyle ?? _$defaultTextStyle;

  /// the controller value or widget value
  num get currentValue => widget.controller?.value ?? widget.value!;

  final List<_AnimatedSingleWidget> _widgets = [];

  num _value = 0.0;

  /// value get,
  num get value => _value;

  /// value set
  set value(num newValue) {
    _value = newValue;
    if (mounted) {
      setState(() {});
    }
  }

  /// is negative number
  bool get isNegative => _value.isNegative;

  @override
  void initState() {
    super.initState();
    WidgetsBindingx.instance?.addObserver(this);
    widget.controller?.addListener(_updateValue);
    value = currentValue;
  }

  String _getFormatValueAsString() {
    return _formatNum(
      _value.toString(),
      fractionDigits: widget.fractionDigits,
    );
  }

  void _updateValue() {
    value = currentValue;
  }

  void _markNeedRebuild() {
    _widgets.clear();
    _dirty = true;
    _updateValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mq = MediaQuery.maybeOf(context);
    final sdp = SingleDigitProvider.maybeOf(context);
    if (_mediaQueryData?.textScaleFactor != mq?.textScaleFactor ||
        _singleDigitData != sdp) {
      _markNeedRebuild();
    }
    _mediaQueryData = mq;
    _singleDigitData = sdp;
  }

  @override
  void reassemble() {
    super.reassemble();
    _markNeedRebuild();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    _markNeedRebuild();
  }

  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    _markNeedRebuild();
  }

  String _formatNum(String numstr, {int fractionDigits = 2}) {
    String result;
    final String _numstr = isNegative ? numstr.replaceFirst("-", "") : numstr;
    final List<String> numSplitArr = num.parse(_numstr).toString().split('.');
    if (numSplitArr.length < 2) {
      numSplitArr.add("".padRight(fractionDigits, '0'));
    }
    if (!widget.enableSeparator && fractionDigits < 1) {
      result = numSplitArr.first;
    }
    final List<String> digitList =
        List.from(numSplitArr.first.characters, growable: false);
    if (widget.enableSeparator) {
      int len = digitList.length - 1;
      final separateSymbol = widget.separateSymbol ?? "";
      if (separateSymbol.isNotEmpty) {
        for (int index = 0, i = len; i >= 0; index++, i--)
          if (index % widget.separateLength == 0 && i != len)
            digitList[i] += separateSymbol;
      }
    }
    // handle fraction digits
    if (fractionDigits > 0) {
      List<String> fractionList = List.from(numSplitArr.last.characters);
      if (fractionList.length > fractionDigits) {
        fractionList =
            fractionList.take(fractionDigits).toList(growable: false);
      } else {
        final padRightLen = fractionDigits - fractionList.length;
        //Equivalent to `padRight(padRightLen, "0")`
        fractionList.addAll(List.generate(padRightLen, (index) => "0"));
      }
      final strbuff = StringBuffer()
        ..writeAll(digitList)
        ..write(widget.decimalSeparator)
        ..writeAll(fractionList);
      result = strbuff.toString();
    } else {
      result = digitList.join('');
    }

    return result;
  }

  @override
  void didUpdateWidget(AnimatedDigitWidget oldWidget) {
    widget.controller?.removeListener(_updateValue);
    super.didUpdateWidget(oldWidget);
    widget.controller?.addListener(_updateValue);
    if (widget.controller == null) {
      _updateValue();
    }
  }

  @override
  void dispose() {
    WidgetsBindingx.instance?.removeObserver(this);
    widget.controller?.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.valueColors != null) {
      _singleDigitData = SingleDigitData(
        useTextSize: true,
        valueColors: widget.valueColors,
      );
    }

    if (_dirty) {
      _rebuild();
    } else {
      _update();
    }
    _dirty = false;

    if (_singleDigitData != null) {
      return SingleDigitProvider(
        data: _singleDigitData!,
        child: _build(),
      );
    }

    return _build();
  }

  Widget _build() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefix != null) _buildChangeTextColorWidget(widget.prefix!),
        _buildNegativeSymbol(),
        ..._widgets,
        if (widget.suffix != null) _buildChangeTextColorWidget(widget.suffix!),
      ],
    );
  }

  Widget _buildChangeTextColorWidget(String val) {
    Widget result = Text(val, style: style);
    final sdd = _singleDigitData;
    if (sdd == null || !sdd.prefixAndSuffixFollowValueColor) return result;
    return sdd._buildChangeTextColorWidget(val, style) ?? result;
  }

  void _rebuild([String? value]) {
    _widgets.clear();
    String newValue = value ?? _getFormatValueAsString();
    for (var i = 0; i < newValue.length; i++) {
      _addAnimatedSingleWidget(newValue[i]);
    }
  }

  void _update() {
    String newValue = _getFormatValueAsString();
    final int lenNew = newValue.length;
    final int lenOld = _widgets.length;
    if (value == 0 || lenNew == lenOld) {
      if (lenNew < lenOld) {
        _widgets.removeRange(
            lenNew - 1,
            (lenOld - lenNew) +
                widget.fractionDigits +
                (widget.fractionDigits > 0 ? 1 : 0));
      }
      for (var i = 0; i < (lenNew == 0 ? 1 : lenNew); i++) {
        final String curr = newValue[i];
        _setValue(_widgets[i].key, curr);
      }
    } else {
      _rebuild(newValue);
    }
  }

  Widget _buildNegativeSymbol() {
    final String symbolKey = "_AdwChildSymbol";
    Widget secondChild = _singleDigitData?._buildChangeTextColorWidget(
            "-", style, ValueKey(symbolKey)) ??
        Text("-", key: ValueKey(symbolKey), style: style);
    return AnimatedCrossFade(
      key: ValueKey("_AdwAnimaNegativeSymbol"),
      firstChild: Text("", key: ValueKey(symbolKey), style: style),
      secondChild: secondChild,
      sizeCurve: widget.curve,
      firstCurve: widget.curve,
      secondCurve: widget.curve,
      duration: widget.duration,
      reverseDuration: widget.duration,
      crossFadeState:
          isNegative ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  void _setValue(Key? _aswsKey, String value) {
    assert(_aswsKey != null);
    if (_aswsKey is GlobalKey<_AnimatedSingleWidgetState>) {
      _aswsKey.currentState?.setValue(value);
    }
  }

  void _addAnimatedSingleWidget(String value) {
    _widgets.add(_buildSingleWidget(value));
  }

  _AnimatedSingleWidget _buildSingleWidget(String value) {
    return _AnimatedSingleWidget(
      initialValue: value,
      textStyle: style,
      boxDecoration: widget.boxDecoration,
      duration: widget.duration,
      curve: widget.curve,
      textScaleFactor: _mediaQueryData?.textScaleFactor,
      singleDigitData: _singleDigitData,
      loop: widget.loop,
      autoSize: widget.autoSize,
      animateAutoSize: widget.animateAutoSize,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', currentValue.toDouble()));
  }
}

/// single
class _AnimatedSingleWidget extends StatefulWidget {
  /// textStyle
  final TextStyle textStyle;

  /// duration
  final Duration duration;

  /// curve
  final Curve curve;

  /// boxDecoration
  final BoxDecoration? boxDecoration;

  /// initialValue
  final String initialValue;

  /// The [MediaQueryData] in textScaleFactor
  final double? textScaleFactor;

  final SingleDigitData? singleDigitData;

  /// loop scroll
  final bool loop;

  /// auto scale text size
  final bool autoSize;

  /// use animate scale text size scale
  final bool animateAutoSize;

  _AnimatedSingleWidget({
    required this.initialValue,
    required this.textStyle,
    required this.duration,
    required this.curve,
    this.boxDecoration,
    this.textScaleFactor,
    this.singleDigitData,
    this.loop = false,
    this.autoSize = false,
    this.animateAutoSize = false,
  }) : super(key: GlobalKey<_AnimatedSingleWidgetState>());

  @override
  State<StatefulWidget> createState() {
    return _AnimatedSingleWidgetState();
  }
}

class _AnimatedSingleWidgetState extends State<_AnimatedSingleWidget> {
  @override
  void initState() {
    super.initState();
    data = widget.singleDigitData;
    currentValue = widget.initialValue;
    _initSize();
    _animateTo();
  }

  SingleDigitData? data;

  bool get canAutoSize => data?.size == null;

  /// see [AnimatedDigitWidget.loop]
  bool get loop => widget.loop;

  /// text style
  TextStyle get _textStyle => widget.textStyle;

  /// box decoration
  BoxDecoration? get _boxDecoration => widget.boxDecoration;

  /// scroll duration
  Duration get _duration => widget.duration;

  /// animate curve
  Curve get _curve => widget.curve;

  /// 数字滚动控制
  late final ScrollController scrollController = ScrollController();

  /// 当前值(数字、符号、给定 [SingleDigitData.size])的尺寸大小
  Size valueSize = Size.zero;

  /// 每次需要滚动的距离，由 [_computeScrollOffset] 计算得到
  double scrollOffset = 0.0;

  /// private old value
  String oldValue = "0";

  /// private currentValue
  String _currentValue = "0";

  /// currentValue get
  String get currentValue => _currentValue;

  /// currentValue set
  set currentValue(String val) {
    oldValue = _currentValue;
    _currentValue = val;
    _checkValue();
    if (canAutoSize && widget.autoSize) {
      _initSize();
      setState(() {});
    }
  }

  /// 设置一个新的值
  void setValue(String newValue) {
    currentValue = newValue;
    _animateTo();
  }

  /// 是否为非数字的符号
  bool get isNumber => _isNumber;
  bool _isNumber = true;

  /// 检查当前的值是否为数字, 使用十进制转换
  ///
  /// check value is number type，decimal number convert
  ///
  /// **[radix]**:`null`
  /// ```dart
  /// int.tryParse('0xff') == 255; // true
  /// ```
  void _checkValue() {
    _isNumber = int.tryParse(_currentValue, radix: 10) != null;
  }

  /// 初始化当前值的 Size | 指定的 Size
  Size _initSize() {
    if (widget.singleDigitData != null) {
      if (widget.singleDigitData!.size != null && !data!.useTextSize) {
        return valueSize = widget.singleDigitData!.size!;
      }
    }
    return valueSize = _getTextSize(currentValue);
  }

  /// ## 获取 [text] 的 Size
  Size _getTextSize(String text) {
    final window = WidgetsBindingx.instance?.window;
    final fontWeight = window?.accessibilityFeatures.boldText ?? false
        ? FontWeight.bold
        : _textStyle.fontWeight == FontWeight.bold
            ? FontWeight.bold
            : FontWeight.normal;
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: widget.autoSize ? text : (isNumber ? "0" : text),
        style: _textStyle.copyWith(fontWeight: fontWeight),
      ),
      textScaleFactor: widget.textScaleFactor ?? window?.textScaleFactor ?? 1.0,
    );
    painter.layout();
    return painter.size;
  }

  /// 动画滚动到当前的数字
  void _animateTo() {
    if (isNumber && oldValue != currentValue) {
      WidgetsBindingx.instance?.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          _scrollTo();
        }
      });
    }
  }

  /// 滚动到距离 [scrollOffset]
  Future<void> _scrollTo() async {
    _computeScrollOffset();
    await scrollController.animateTo(
      scrollOffset,
      duration: _duration,
      curve: _curve,
    );
  }

  /// 计算需要滚动的距离 [scrollOffset]
  void _computeScrollOffset() {
    final int? n = int.tryParse(currentValue);
    if (n == null) return;
    if (loop) {
      final int? c = int.tryParse(oldValue);
      if (c != null) {
        final value = c > n ? 10 - c + n : n - c;
        scrollOffset += value * valueSize.height;
      }
    } else {
      scrollOffset = n * valueSize.height;
    }
  }

  @override
  void dispose() {
    if (loop || isNumber) scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget child = Center(
      widthFactor: 1.0,
      child: _build(),
    );
    if (widget.autoSize && widget.animateAutoSize) {
      child = AnimatedContainer(
        width: valueSize.width,
        height: valueSize.height,
        decoration: _boxDecoration,
        child: child,
        duration: _duration,
      );
    } else {
      child = Container(
        width: valueSize.width,
        height: valueSize.height,
        decoration: _boxDecoration,
        child: child,
      );
    }
    return AbsorbPointer(
      absorbing: true,
      child: child,
    );
  }

  /// 创建单个滚动 Widget
  ///
  /// [isNumber] 为 `true` 时才创建数字滚动容器
  Widget _build() {
    if (isNumber) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: _buildDigitScrollContainer(),
      );
    }
    return _buildSingleWidget(currentValue);
  }

  /// Bulid 数字滚动容器
  ///
  /// 根据 [loop] 构建出对应的滚动容器
  Widget _buildDigitScrollContainer() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: loop ? null : 10,
      itemExtent: valueSize.height,
      itemBuilder: (_, i) {
        final val = loop ? i % 10 : i;
        return _buildSingleWidget(val.toString());
      },
    );
  }

  /// 默认的构建单个 Widget 的内容
  Widget defaultBuildSingleWidget(String val) {
    return Text(val, style: _textStyle);
  }

  /// 根据配置构建单个 Widget 的内容
  Widget _buildSingleWidget(String val) {
    Widget child = defaultBuildSingleWidget(val);
    if (data == null) return child;
    final SingleDigitData sdd = data!;
    child = sdd._buildChangeTextColorWidget(val, _textStyle) ?? child;
    if (sdd.builder != null) {
      child = sdd.builder!(valueSize, val, isNumber, child);
    }
    if (!sdd.useTextSize && sdd.size != null) {
      child = SizedBox.fromSize(
        size: valueSize,
        child: child,
      );
    }
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
