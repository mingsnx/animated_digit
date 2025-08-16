## [3.2.4] - publish 3.2.4
* fix [#18](https://github.com/mingsnx/animated_digit/pull/18) and merge pull.
* 🍓 告知：这个 `<3.3+` 是 `sdk: <3.0.0` 以下的支持版本，`sdk: >= 3.0.0+` 的版本在 3.3+ 后续发布
* 🍓 Notification: This applies to versions < 3.3+ (supporting sdk: < 3.0.0). Versions with sdk: >= 3.0.0+ will be included in subsequent releases starting from 3.3+.

## [3.2.3] - publish 3.2.3
* upgrade: 'window' is deprecated and shouldn't be used. Look up the current FlutterView from the context via View.of(context) or consult the PlatformDispatcher directly instead. Deprecated to prepare for the upcoming multi-window support. This feature was deprecated after v3.7.0-32.0.pre.

```dart
final window = WidgetsBinding.instance.window; // deprecated
```

## [3.2.2] - publish 3.2.2
* FIX: #10

## [3.2.1] - publish 3.2.1
* adapted Flutter 2 ~ 3
* added change color based on value.
**ex**
```dart
int value = 9999; // or use Controller.value
AnimatedDigitWidget(
  value: value,
  textStyle: TextStyle(
    color: Colors.orange[200],
    fontSize: 30,
  ),
  valueColors: [
    ValueColor(
      //When value <= 0 , the color changes to red
      condition: () => value <= 0,
      color: Colors.red,
    ),
    // you can add more ...，but always take the last eligible.
  ],
),
```
## [3.1.3] - publish 3.1.3
* 3.1.3 release
* fix _setValue null error
## [3.1.2] - publish 3.1.2
* 3.1.2 release
* cancel `prefix` and `suffix` middle of space.
* added negative symbol animation.
## [3.1.1] Retracted Package Version.(fix error doc)
## [3.1.0] - publish 3.1.0
* 3.1.0 release
* 优化自动伸缩尺寸的动画
* optimization autoSize animation
* added Controller API `minusValue`
* added Controller API `timesValue`
* added Controller API `divideValue`
* added `prefix`
* **widget params name change | 参数名称变更**
  - `enableDigitSplit` => `enableSeparator`
  - `digitSplitSymbol` => `separateSymbol`
  - `separatorDigits` => `separateLength`
* change `loop` default value => `true` (orgin `false`)
* change `autoSize` default value => `true` (orgin `false`)
* remove `singleBuilder`


## [3.0.0] - publish 3.0.0
* 3.0.0 release
* added `loop` (default `false`), example:
```dart
AnimatedDigitWidget(
  value: 2022,
  loop: true,
),
```
* added `singleBuilder`, example:
```dart
AnimatedDigitWidget(
  value: 2022,
  loop: true,
  separatorDigits: 1,
  digitSplitSymbol: "#",
  enableDigitSplit: true,
  singleBuilder: (size, value, isNumber, defaultBuilder) {
    return isNumber ? defaultBuilder() : FlutterLogo();
  },
),
```
**run result**

[![TO0f56.png](https://s4.ax1x.com/2022/01/04/TO0f56.png)](https://imgtu.com/i/TO0f56)

* added `SingleDigitProvider` Widget, this is `InheritedWidget`. 
> 它可以控制每个数字或符号的包装盒的大小和改变显示它们的方式，它比 `singleBuilder` 权利更大
>
> it can control the size of every digit/symbol wrapper box and change the way of display them, 
> more powerful than `singleBuilder`

**example**
```dart
SingleDigitProvider(
  data: SingleDigitData(
    syncContainerValueSize: false,
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
```
[![TOrgbj.png](https://s4.ax1x.com/2022/01/04/TOrgbj.png)](https://imgtu.com/i/TOrgbj)

* added `autoSize` (default `false`). 

**resolve** https://github.com/mingsnx/animated_digit/pull/3#issuecomment-1005552717

[![7EOszV.md.gif](https://s4.ax1x.com/2022/01/10/7EOszV.md.gif)](https://imgtu.com/i/7EOszV)

* added `animateAutoSize` (default `false`)


## [2.2.0] - publish 2.2.0
* 2.2.0 release
* ✅ null-safety Version!.
* ✅ Fix use MediaQueryData.textScaleFactor
* 🍇 added `formatter`, example:
```dart
AnimatedDigitWidget(
  value: 2022,
  formatter: (val) => "Hello ~ $val",
),
// => Hello ~ 2022
```
* 🍓 cancel assert separatorDigits >= 2, change to separatorDigits >= 1

## [2.1.1] - 
* added decimalSeparator
* added suffix

## [2.1.0] - init late final scrollController resolve null value
* 2.1.0 release
* ✅ null-safety Version!.
* ✅ use late final scrollController resolve init null value

## [2.0.8] - fix scrollController null check
* 2.0.8 release
* ✅ null-safety Version!.
* ✅ fix scrollController null check
* ✅ 修复 scrollController 空检查

## [2.0.6] - When you don’t need a controller, you can use the value field
* 2.0.6 release
* ✅ null-safety Version!.
* ✅ When you don’t need a controller, you can use the value field
* ✅ 当不需要控制器时，可以使用 value 字段

## [2.0.4] - null-safety Version. resolve text textScaleFactor
* 2.0.4 release
* ✅ null-safety Version!.
* ✅ resolve textScaleFactor
* ✅ 解决设备字体因 textScaleFactor 改变的影响
* + duration field
## [2.0.2] - null-safety Version. Fix the effect of digitSplitSymbol after negative numbers
* 2.0.2 release
* ✅null-safety Version!.
* ✅Fix the effect of digitSplitSymbol after negative numbers
* ✅修复负数后digitSplitSymbol的影响
## [2.0.1] - not null-safety Version. Fix the effect of digitSplitSymbol after negative numbers
* 2.0.1 release
* ✅not null-safety Version!.
* ✅Fix the effect of digitSplitSymbol after negative numbers
* ✅修复负数后digitSplitSymbol的影响

## [2.0.0] - Migrate to null-safety.
* 2.0.0 release
* ✅Migrate to null-safety.
* ✅迁移至空安全

## [1.0.6] - Fix BUG Cannot scroll after calling'addValue' or'resetValue' for the second time
* 1.0.6 release
* ✅Cannot scroll after calling'addValue' or'resetValue' for the second time
* ✅第二次调用“ addValue”或“ resetValue”后无法滚动

## [1.0.5+1] - property digitSplitSymbol name modify error
* 1.0.5+1 release
* (property modify error) <= 1.0.4 digitSplitSymbol => (1.0.5)❌digitSplitNumber => (now)✅digitSplitSymbol 

## [1.0.5] - Prevent ScrollController not attached to any scroll views
* 1.0.5 release
* Add assert、annotation
* Part param default handler
* Prevent ScrollController not attached to any scroll views

## [1.0.4] - Fix that integers are not supported
* 1.0.4 release
* 修复支持整数

## [1.0.3] - optimization
* 1.0.3 release
* 区分分隔字符和数字的Size计算

## [1.0.2] - solve digital precision
* 1.0.2 release. 
* solve digital precision
* 引入 number_precision 解决数字精度git add .

## [1.0.1] - reset bug
* 1.0.1 release. 
* reset bug

## [1.0.0] - first publish.
* 1.0.0 release.