# animated_digit

一个会上下滚动数字的 AnimatedWidget
widget that can scroll up and down

## Usage

``` dart
AnimatedDigitController _controller = AnimatedDigitController(520);

AnimatedDigitWidget(
  controller: _controller,
  textStyle: TextStyle(color: Color(0xff009668)),
  fractionDigits: 2,
  enableDigitSplit: true,
)

_controller.addValue(1314);

_controller.resetValue(1314);
```