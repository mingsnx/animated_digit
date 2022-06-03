///
/// Copyright (c) by pub.dev number_precision 2.0.2+1
///
/// pub.dev: https://pub.dev/packages/number_precision
///
/// github: https://github.com/luoyelusheng/number_precision
///
/// Author：luoyelusheng@gmail.com
///
import 'dart:math';

/// The smallest possible value of an int within 64 bits.
const int intMinValue = -9007199254740991;

/// The biggest possible value of an int within 64 bits.
const int inMaxValue = 9007199254740991;

class NP {
  static bool _boundaryCheckingState = true;

  /// 字符串转为[num]类型
  /// [number] 数据
  static num parseNum(dynamic number) {
    if (number is num) {
      return number;
    } else if (number is String) {
      return num.parse(number);
    } else {
      throw FormatException('$number is not of type num and String');
    }
  }

  /// 把错误的数据转正
  /// strip(0.09999999999999998)=0.1
  /// [number] 数据 [precision] 截取小数位
  static num strip(dynamic number, {int precision = 14}) {
    return num.parse(parseNum(number).toStringAsFixed(precision));
  }

  /// 返回小数的位数
  /// [number] 数据
  static num digitLength(dynamic number) {
    final eSplit = parseNum(number).toString().toLowerCase().split('e');
    final digit = eSplit[0].split('.');
    final len = (digit.length == 2 ? digit[1].length : 0) -
        (eSplit.length == 2 ? int.parse(eSplit[1]) : 0);
    return len > 0 ? len : 0;
  }

  /// 把小数转成整数，支持科学计数法。如果是小数则放大成整数
  /// [number] 数据
  static num float2Fixed(dynamic number) {
    final dLen = digitLength(number);
    if (dLen <= 20) {
      if (number is String) {
        if (number.toLowerCase().indexOf('e') == -1) {
          return num.parse(number.replaceAll('.', ''));
        }
        return num.parse(num.parse(number)
            .toStringAsFixed(dLen as int)
            .replaceAll(dLen == 0 ? '' : '.', ''));
      } else if (number is num) {
        return num.parse(number
            .toStringAsFixed(dLen as int)
            .replaceAll(dLen == 0 ? '' : '.', ''));
      }

      throw FormatException('$number is not of type num and String');
    }
    throw Exception(
        '$number is beyond boundary when transfer to integer, the results may not be accurate');
  }

  /// 检测数字是否越界，如果越界给出提示
  /// [number] 数据
  static void checkBoundary(dynamic number) {
    if (_boundaryCheckingState) {
      if (number > inMaxValue || number < intMinValue) {
        throw Exception(
            '$number is beyond boundary when transfer to integer, the results may not be accurate');
      }
    }
  }

  /// 精确乘法
  /// [num1] 左操作数 [num2]右操作数
  /// [others] 更多操作数使用数组传递
  ///
  /// 譬如 times(1, 2, [22,33])
  static num times(dynamic num1, dynamic num2, [List<dynamic>? others]) {
    if (others != null) {
      return times(times(num1, num2), others[0],
          others.length >= 2 ? others.sublist(1) : null);
    }
    num num1Changed = float2Fixed(num1);
    num num2Changed = float2Fixed(num2);
    num baseNum = digitLength(num1) + digitLength(num2);
    dynamic leftValue = num1Changed * num2Changed;

    checkBoundary(leftValue);

    return NP.strip(leftValue / pow(10, baseNum));
  }

  /// 精确加法
  static num plus(dynamic num1, dynamic num2, [List<dynamic>? others]) {
    if (others != null) {
      return plus(plus(num1, num2), others[0],
          others.length >= 2 ? others.sublist(1) : null);
    }
    num baseNum = pow(10, max(digitLength(num1), digitLength(num2)));
    return (times(num1, baseNum) + times(num2, baseNum)) / baseNum;
  }

  /// 精确减法
  static num minus(dynamic num1, dynamic num2, [List<dynamic>? others]) {
    if (others != null) {
      return minus(minus(num1, num2), others[0],
          others.length >= 2 ? others.sublist(1) : null);
    }
    num baseNum = pow(10, max(digitLength(num1), digitLength(num2)));

    return (times(num1, baseNum) - times(num2, baseNum)) / baseNum;
  }

  /// 精确除法
  static num divide(dynamic num1, dynamic num2, [List<dynamic>? others]) {
    if (others != null) {
      return divide(divide(num1, num2), others[0],
          others.length >= 2 ? others.sublist(1) : null);
    }
    num num1Changed = float2Fixed(num1);
    num num2Changed = float2Fixed(num2);
    checkBoundary(num1Changed);
    checkBoundary(num2Changed);
    return times(num1Changed / num2Changed,
        (pow(10, digitLength(num2) - digitLength(num1))));
  }

  /// 四舍五入
  static num round(dynamic number, int ratio) {
    num base = pow(10, ratio);
    return divide((times(number, base).round()), base);
  }

  /// 是否进行边界检查，默认开启
  /// [flag] 标记开关，true 为开启，false 为关闭，默认为 true
  static void enableBoundaryChecking([flag = true]) {
    _boundaryCheckingState = flag;
  }
}
