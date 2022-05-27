import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:string_validator/string_validator.dart';

class CalcButton {
  final String label;
  final bool textAccent;
  final bool backgroundAccent;

  CalcButton(
    this.label, {
    this.textAccent = false,
    this.backgroundAccent = false,
  });
}

class CalcController extends GetxController {
  final input = "".obs;
  final output = "0".obs;
  final explainedOutput = "".obs;
  final Color calcTextColor = Colors.deepPurple.shade50;
  final buttons = [
    CalcButton("AC", textAccent: true),
    CalcButton("+/-", textAccent: true),
    CalcButton("%", textAccent: true),
    CalcButton("C", textAccent: true),
    //----
    CalcButton("7"),
    CalcButton("8"),
    CalcButton("9"),
    CalcButton("/", textAccent: true),
    //----
    CalcButton("4"),
    CalcButton("5"),
    CalcButton("6"),
    CalcButton("x", textAccent: true),
    //----
    CalcButton("1"),
    CalcButton("2"),
    CalcButton("3"),
    CalcButton("-", textAccent: true),
    //----
    CalcButton("."),
    CalcButton("0"),
    CalcButton("=", backgroundAccent: true),
    CalcButton("+", textAccent: true),
  ];

  calculate(String label, int index) {
    // Clear Button
    if (index == 0) {
      input.value = '';
      output.value = '0';
    }
    // +/- button
    else if (index == 1) {
      if (contains(input.value, "-")) {
        String data = input.value.replaceAll("-", "+");
        output.value = data;
      } else if (input.startsWith("+", 0)) {
        String data = input.value.replaceFirst("+", "-", 0);
        output.value = data;
      } else if (input.isEmpty) {
      } else {}
    }
    // % Button
    else if (index == 2) {
      if (['+', '-', 'x', '/'].contains(input.value[input.value.length - 1])) {
        input.value = input.substring(0, input.value.length - 1) + label;
      }
      try {
        Parser p = Parser();
        ContextModel cm = ContextModel();
        String sanitizedInput1 = input.split('x')[0];
        String sanitizedInput2 = input.split('x')[1];
        Expression exp = p.parse(sanitizedInput1);
        double saniInput = exp.evaluate(EvaluationType.REAL, cm);
        double eval = saniInput * double.parse(sanitizedInput2) / 100;
        output.value = eval.toString();
      } catch (e) {
        output.value = "error".tr;
      }
      input.value += label;
    }
    // Delete Button
    else if (index == 3) {
      input.value = input.substring(0, input.value.length - 1);
    }
    // Equal_to Button
    else if (index == 18) {
      try {
        Parser p = Parser();
        if (['+', '-', 'x', '/']
            .contains(input.value[input.value.length - 1])) {
          input.value = input.substring(0, input.value.length - 1);
        }
        Expression exp = p.parse(input.replaceAll('x', '*'));
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        output.value = eval.toString();
      } catch (e) {
        output.value = "error".tr;
      }
    } else if ([7, 11, 15, 19].contains(index)) {
      try {
        Parser p = Parser();
        Expression exp = p.parse(input.replaceAll('x', '*'));
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        output.value = eval.toString();
      } catch (e) {
        output.value = "error".tr;
      }
      if (['+', '-', 'x', '/'].contains(input.value[input.value.length - 1])) {
        input.value = input.substring(0, input.value.length - 1) + label;
      } else {
        input.value += label;
      }
    }
    //  other buttons
    else {
      input.value += label;
    }
  }
}
