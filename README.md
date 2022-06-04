
<p align="center">
  <a href="https://flutter.dev/">
    <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-ar21.svg" alt="flutter" style="vertical-align:top; margin:4px;">
  </a>
  <a href="https://dart.dev/">
    <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-ar21.svg" alt="dart" style="vertical-align:top; margin:4px;">
  </a>
</p>

<p align="center">
  English | <a href="https://github.com/mingsnx/animated_digit/blob/master/README.cn-zh.md">中文简体</a>
</p>

# animated_digit

Scroll animation numbers widget, any number that need  animation effects and easy to use.

![Example GIF](https://raw.githubusercontent.com/mingsnx/animated_digit/master/example/animat-digit-example.gif)

## Usage

#### 🚴🏻 Easy Show
```dart
// only show
AnimatedDigitWidget(
  value: 9999
),
```
#### 🚄 Easy Show & State
```dart
// simple state control 
int value = 9999;
AnimatedDigitWidget(
  value: value
  textStyle: TextStyle(color: Colors.pink),
),
setState((){
  value = 191919;
});
```

#### 🎡 Controller
> Built-in accuracy calculation
```dart
AnimatedDigitController _controller = AnimatedDigitController(10240.987);

AnimatedDigitWidget(
  controller: _controller,
  textStyle: TextStyle(color: Colors.pink),
  fractionDigits: 2, // number of decimal places reserved, not rounded
  enableSeparator: true, // like this 10,240.98
),
// UI Result => 10,240.98

// increment 
_controller.addValue(1314);

// minus 
_controller.minusValue(1314); // from v3.1.0 added

// times 
_controller.timesValue(1314); // from v3.1.0 added

// divide 
_controller.divideValue(1314); // from v3.1.0 added

// reset
_controller.resetValue(1314);

// last
_controller.dispose();
```

### 🖼 UI Effect Image & 💻 Code Example

[![7Dcj6f.png](https://s4.ax1x.com/2022/01/19/7Dcj6f.png)](https://imgtu.com/i/7Dcj6f)
```dart
AnimatedDigitWidget(
  value: 12531.98, // or use controller
),
```
[![7DcznS.png](https://s4.ax1x.com/2022/01/19/7DcznS.png)](https://imgtu.com/i/7DcznS)
```dart
AnimatedDigitWidget(
  value: 12531.98, // or use controller
  enableSeparator: true,
),
```
[![7DcX1P.png](https://s4.ax1x.com/2022/01/19/7DcX1P.png)](https://imgtu.com/i/7DcX1P)
```dart
AnimatedDigitWidget(
  value: 12531.98, // or use controller
  fractionDigits: 2,
  enableSeparator: true,
),
```
[![7DcOpt.png](https://s4.ax1x.com/2022/01/19/7DcOpt.png)](https://imgtu.com/i/7DcOpt)
```dart
SingleDigitProvider(
  data: SingleDigitData(
    useTextSize: true,
    builder: (size, value, isNumber, child) {
      return isNumber ? child : FlutterLogo();
    },
  ),
  child: AnimatedDigitWidget(
    value: 12531.98, // or use controller
    textStyle: TextStyle(color: Colors.pink[200], fontSize: 30),
    separateLength: 1,
    separateSymbol: "#",
    enableSeparator: true,
  ),
),
```
[![7DcvX8.png](https://s4.ax1x.com/2022/01/19/7DcvX8.png)](https://imgtu.com/i/7DcvX8)
```dart
AnimatedDigitWidget(
  value: 12531.98, // or use controller
  textStyle: TextStyle(color: Colors.orangeAccent.shade700, fontSize: 30),
  fractionDigits: 2,
  enableSeparator: true,
  separateSymbol: "·",
  separateLength: 3,
  decimalSeparator: ",",
  prefix: "\$",
  suffix: "€",
),
```

### ✌ If you want to change color based on value
Wrap a `SingleDigitProvider`, then add a `ValueColor` object to `valueChangeColors` in `SingleDigitData`, which is an array, you can add more ...，but always take the last eligible
```dart
int value = 9999; // or use Controller.value
AnimatedDigitWidget(
  value: value,
  textStyle: TextStyle(
    color: Colors.orange[200],
    fontSize: 30,
  ),
  valueChangeColors: [
    ValueColor(
      //When value <= 0 , the color changes to red
      condition: () => value <= 0,
      color: Colors.red,
    ),
    // you can add more ...，but always take the last eligible.
  ],
),
```

### 🐳 Widget Params & [Documentation](https://pub.dev/documentation/animated_digit/latest/animated_digit/AnimatedDigitWidget-class.html)

#### **🚀 Required Params**
> ⚠️ `value` and `controller` cannot be both `null`.
> ⚠️ `controller` has higher priority.
- **`controller`**  - digit controller, The displayed number can be controlled via `addValue` and `resetValue`.
<br />

- **`value`** - the display number.
<br />

#### **🍑 TextStyle And BoxStyle Setting**

- **`textStyle`**  - the numbers text style.
- **`boxDecoration`** - Use with `decoration` of `Container`.
<br />

#### **🍇 Int Type(default) Or Decimal Type Setting**

- **fractionDigits** - the fraction digits, `int`, **default** `0`. 
  - 🖌 **Example ( `1000520.98765` )**:
  - `0` => `1000520`; 
  - `1` => `1000520.9`;
  - `2` => `1000520.98`;
  - `3` => `1000520.987`;
  -  `N` => `1000520.[N]`; 

> The default `0` means an integer, when it is a decimal, if the value is less than the `fractionDigits`, it will be filled with `0` to the right, and the truncation method is used, so there is no rounding.

<br />

#### **🍓 Numbers Free Style Setting**

- **`decimalSeparator`** - the decimal separator，can be replaced by other symbols in place of decimal separators, **default** `.`.
<br />

- **`enableSeparator`** - enable digit separator. **default** `false` not enable, only `true`, `separateLength` and `separateSymbol` valid.
  - 🖌 **Example (`true`)**: `1000520` => `1,000,520` (seealso `separateLength` or `separateSymbol`)
<br />

- **`separateSymbol`** - the numbers separator symbol (only enableSeparator is true), make numbers much easier to read, **default** `,`.
  - 🖌 **Example ( `1000520` )**:
  - `,` => `1,000,520` 
  - `'` => `1'000'520` 
  - `-` => `1-000-520`
<br />

- **`separateLength`** - the numbers separator length (only enableSeparator is true), `separateSymbol` by separator length insert, **default** `3`.
  - 🖌 **Example ( `1000520` )**:
  - `1` => `1,0,0,0,5,2,0` 
  - `2` => `1,00,05,20` 
  - `3` => `1,000,520`
<br />

#### **🥝 Scroll Animation Setting** 

- **`duration`** - the animate duration, **default** Duration(milliseconds: 300).
- **`curve`** - the animate curve, **default** Curves.easeInOut. [look animate curve](https://flutter.github.io/assets-for-api-docs/assets/animation/curve_ease_in_out.mp4).
- **`loop`** - enable loop scroll animate. **default** true, always scroll down, not scroll up from 9 -> 0; `false`, scroll up and down.
<br />

#### **🍎 Digital Size Scheme Setting**

- **`autoSize`** - the default true is to automatically expand and contract according to the size of the ( `number` / `symbol` ) itself, false, the text size of the number `0` is used as the container size of each number, which can ensure the same width, but it seems that there is a slight interval between `1` and other numbers 😊 .
<br />

- **`animateAutoSize`** - the animation resizing. default `true`, `false` will change directly to the size of the number/symbol.
<br />

#### **🍒 Number prefix and suffix Setting**

- **`prefix`** - the text to display in front of the counter.
- **`suffix`** - the text to display after the counter. 
<br />

### Thanks
[number_precision](https://pub.dev/packages/number_precision)
