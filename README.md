
<p align="center">
  <a href="https://flutter.dev/">
    <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-ar21.svg" alt="flutter" style="vertical-align:top; margin:4px;">
  </a>
  <a href="https://dart.dev/">
    <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-ar21.svg" alt="dart" style="vertical-align:top; margin:4px;">
  </a>
</p>
<br/>

> null-safety version 
> 
> [![Pub](https://shields.io/badge/pub-v2.0.4-ff69b4)](https://pub.flutter-io.cn/packages/animated_digit/versions/2.0.6)

> not null-safety version 
> 
> [![Pub](https://shields.io/badge/pub-v2.0.1-ff69b4)](https://pub.flutter-io.cn/packages/animated_digit/versions/2.0.1)



# animated_digit

一个上下滚动的数字动画 widget，可以用于展示会动的金额、实时在线人数、
凡是需要动画效果的数字，简单易用，也能保证金额精度计算。

A scrolling digital animation widget that can be used to display the amount of animation, the number of people online in real-time,
Any number that requires animation effects is simple and easy to use, and it can also guarantee the accuracy of the amount of calculation.

![](https://raw.githubusercontent.com/mingsnx/animated_digit/master/example/animat-digit-example.gif)

## Usage

``` dart
AnimatedDigitController _controller = AnimatedDigitController(520);

AnimatedDigitWidget(
  controller: _controller,
  // value: 520, // v2.0.6
  textStyle: TextStyle(color: Color(0xff009668)),
  fractionDigits: 2,
  enableDigitSplit: true,
)

// 累加一个数字 | increment 
_controller.addValue(1314);

// 重置一个数字 | reset
_controller.resetValue(1314);
```

## API

累加一个数字 | addValue
``` dart
AnimatedDigitController _controller = AnimatedDigitController(520);
_controller.addValue(1314); // 1834
```


重置一个数字 | resetValue
``` dart
AnimatedDigitController _controller = AnimatedDigitController(520);
_controller.resetValue(1314); // 1314
```
## 感谢
[number_precision](https://pub.dev/packages/number_precision)
