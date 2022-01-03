import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'number_percision.dart';

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
  Widget Function() defaultBuilder,
);

class SingleDigitData {
  /// 单个字符容器尺寸大小。
  /// 如果为 null，则以数字 `0` 为字体宽高标准计算得到。
  ///
  /// The single container size.
  /// If it is null, it will be calculated with the number `0` as the font width and height standard.
  ///
  Size? size;

  /// 自定义内容 builder
  AnimatedSingleWidgetBuilder? builder;

  bool syncContainerValueSize;

  ///
  SingleDigitData({this.size, this.syncContainerValueSize = true, this.builder});

  @override
  bool operator ==(Object other) {
    if (other is SingleDigitData) {
      return other.size == this.size && other.builder == this.builder;
    }
    return false;
  }

  @override
  int get hashCode => size.hashCode ^ builder.hashCode;
}

class SingleDigitProvider extends InheritedWidget {
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
  bool updateShouldNotify(SingleDigitProvider oldWidget) =>
      data != oldWidget.data;

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

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  /// ### 累加数字 | add value
  ///
  /// ### **⚠️注意⚠️**
  /// * 由于 dart 在 web 中的 int 上限值原因
  /// * 最小值：[int64MinValue] = [-9219999999000000512]，
  /// * 最大值：[int64MaxValue] = [9219999999000000512]
  /// - 即：[-9219999999000000512, 9219999999000000512]
  ///
  /// **能在不丢失精度计算数值**
  ///
  /// - 为什么需要不丢失精度计算？
  ///
  /// - 因为
  /// ```dart
  /// print(0.1 + 0.2); // => 0.30000000000000004
  /// ```
  /// - 所以 [addValue] 内使用了 [NPms.plus]
  /// ```dart
  /// AnimatedDigitController controller = AnimatedDigitController(0.1);
  /// controller.addValue(0.2);
  /// print(controller.value) // => 0.3
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
  /// `<= 0` => 1000520;
  ///
  /// `1` => 1000520.9;
  ///
  /// `2` => 1000520.98;
  ///
  /// `3` => 1000520.987;
  ///
  /// `...` => 1000520.[...];
  final int fractionDigits;

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
  ///   formatter: (val) => "Hello ~ $val", // val is default display result
  /// ),
  /// // => Hello ~ 2021
  /// ```
  final FormatValue? formatter;

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

  /// 自定义 single builder
  /// 每一个数字，每一个字符
  final AnimatedSingleWidgetBuilder? singleBuilder;

  /// see [AnimatedDigitWidget]
  AnimatedDigitWidget({
    Key? key,
    this.controller,
    this.value,
    this.textStyle,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.boxDecoration,
    this.fractionDigits = 0,
    this.enableDigitSplit = false,
    this.digitSplitSymbol = ",",
    this.separatorDigits = 3,
    this.decimalSeparator = '.',
    this.suffix = '',
    this.formatter,
    this.loop = false,
    this.singleBuilder,
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
  SingleDigitData? _singleDigitData;

  /// [didChangeDependencies]依赖发生改变时或触发 [reassemble] 时，会变更成 `true`
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    widget.controller?.addListener(_updateValue);
    value = currentValue;
  }

  String _getFormatValueAsString() {
    var _val = _formatNum(_value.toString(), fractionDigits: widget.fractionDigits);
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

  void _updateValue() {
    value = currentValue;
  }

  void _markNeedRebuild() {
    _widgets.clear();
    _dirty = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mq = MediaQuery.maybeOf(context);
    final sdp = SingleDigitProvider.maybeOf(context);
    if (_mediaQueryData != mq || _singleDigitData != sdp) {
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
    final String _numstr =
        isNegativeNumber ? numstr.replaceFirst("-", "") : numstr;
    final List<String> numString = double.parse(_numstr).toString().split('.');

    if (!widget.enableDigitSplit && fractionDigits < 1) {
      result = numString.first;
      
    }
    final List<String> digitList = List.from(numString.first.characters);
    if (widget.enableDigitSplit) {
      int len = digitList.length - 1;
      final digitSplitSymbol = widget.digitSplitSymbol ?? "";
      for (int index = 0, i = len; i >= 0; index++, i--) {
        if (index % widget.separatorDigits == 0 && i != len)
          digitList[i] = digitList[i] + digitSplitSymbol;
      }
    }
    if (fractionDigits > 0) {
      List<String> fractionList = List.from(numString.last.characters);
      if (fractionList.length > fractionDigits) {
        fractionList =
            fractionList.take(fractionDigits).toList(growable: false);
      } else {
        final padRightLen = fractionDigits - fractionList.length;
        //Equivalent to `padRight(padRightLen, "0")`
        fractionList.addAll(List.generate(padRightLen, (index) => "0"));
      }
      final strbuff = StringBuffer();
      strbuff.writeAll(digitList);
      strbuff.write(widget.decimalSeparator);
      strbuff.writeAll(fractionList);
      result = strbuff.toString();
    } else {
      result = digitList.join('');
    }
    return (isNegativeNumber ? "-" : "") + result;
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
    WidgetsBinding.instance!.removeObserver(this);
    widget.controller?.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dirty) {
      _rebuild();
    } else {
      _update();
    }
    _dirty = false;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: _widgets);
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
    if (newValue.length != _oldValue.length) {
      _rebuild(newValue);
      return;
    }
    for (var i = 0; i < newValue.length; i++) {
      if (i < _oldValue.length) {
        final String old = _oldValue[i];
        final String curr = newValue[i];
        if (old != curr) {
          _setValue(_widgets[i].key, curr);
        }
      } else
        break;
    }
  }

  void _setValue(Key? _aswsKey, String value) {
    assert(_aswsKey != null);
    if (_aswsKey is GlobalKey<_AnimatedSingleWidgetState>) {
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
      singleDigitData: _singleDigitData,
      loop: widget.loop,
      singleBuilder: widget.singleBuilder,
    ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

/// single
class _AnimatedSingleWidget extends StatefulWidget {
  /// textStyle
  final TextStyle? textStyle;

  /// duration
  final Duration? duration;

  /// curve
  final Curve? curve;

  /// boxDecoration
  final BoxDecoration? boxDecoration;

  /// initialValue
  final String initialValue;

  /// The [MediaQueryData] in textScaleFactor
  final double? textScaleFactor;

  final SingleDigitData? singleDigitData;

  final bool? loop;

  /// The [MediaQueryData] in textScaleFactor
  final AnimatedSingleWidgetBuilder? singleBuilder;

  _AnimatedSingleWidget({
    required this.initialValue,
    this.boxDecoration,
    this.duration,
    this.curve,
    this.textStyle,
    this.textScaleFactor,
    this.singleDigitData,
    this.loop,
    this.singleBuilder,
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

  /// see [AnimatedDigitWidget.loop]
  late final bool loop = widget.loop ?? false;

  /// text style
  late final TextStyle _textStyle = widget.textStyle ??
      const TextStyle(
        color: Colors.black,
        fontSize: 25,
      );

  /// box decoration
  BoxDecoration? get _boxDecoration => widget.boxDecoration;

  /// scroll duration
  late final Duration _duration =
      widget.duration ?? const Duration(milliseconds: 300);

  /// animate curve
  late final Curve _curve = widget.curve ?? Curves.easeInOut;

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
    if (widget.singleDigitData?.size != null) {
      return valueSize = widget.singleDigitData!.size!;
    }
    return valueSize = _getTextSize(isNumber ? "0" : currentValue);
  }

  /// 获取 [text] 的 Size
  Size _getTextSize(String text) {
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

  /// 动画滚动到当前的数字
  void _animateTo() {
    if (isNumber) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          _scrollTo();
        }
      });
    }
  }

  /// 滚动到距离 [scrollOffset]
  Future<void> _scrollTo() {
    _computeScrollOffset();
    return scrollController.animateTo(
      scrollOffset,
      duration: _duration,
      curve: _curve,
    );
  }

  /// 计算需要滚动的距离 [scrollOffset]
  void _computeScrollOffset() {
    final int n = int.parse(currentValue);
    if (loop) {
      final int c = int.parse(oldValue);
      final value = c > n ? 10 - c + n : n - c;
      scrollOffset += value * valueSize.height;
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
    final syncUseValueSize = data?.syncContainerValueSize ?? true;
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        width: isNumber ? valueSize.width : syncUseValueSize ? valueSize.width : null,
        height: isNumber ? valueSize.height : syncUseValueSize ? valueSize.height : null,
        decoration: _boxDecoration,
        alignment: Alignment.center,
        child: _build(),
      ),
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
    return Center(
      child: Text(val, style: _textStyle),
    );
  }

  /// 根据配置构建单个 Widget 的内容
  Widget _buildSingleWidget(String val) {
    Widget defaultBuiled() => defaultBuildSingleWidget(val);
    late Widget child;
    if (data?.builder != null) {
      child = data!.builder!(valueSize, val, isNumber, defaultBuiled);
    } else if (widget.singleBuilder != null) {
      child = widget.singleBuilder!(valueSize, val, isNumber, defaultBuiled);
    } else {
      child = defaultBuiled();
    }
    if (isNumber) {
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
