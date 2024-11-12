import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = '';
  String result = '0';

  final List<String> buttons = [
    'C', '⌫', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '0', '.', '=', '',
  ];

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        userInput = '';
        result = '0';
      } else if (buttonText == '⌫') {
        userInput = userInput.isNotEmpty ? userInput.substring(0, userInput.length - 1) : '';
      } else if (buttonText == '=') {
        try {
          Parser parser = Parser();
          Expression expression = parser.parse(userInput);
          double evalResult = expression.evaluate(EvaluationType.REAL, ContextModel());
          result = evalResult.toStringAsFixed(2);
        } catch (e) {
          result = 'Error';
        }
      } else {
        userInput += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(userInput, style: TextStyle(fontSize: 24, color: Colors.white54)),
                  Text(result, style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (BuildContext context, int index) {
                return CalculatorButton(
                  buttonText: buttons[index],
                  onPressed: () => buttonPressed(buttons[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  CalculatorButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = isOperator(buttonText) ? Colors.orange : Colors.white24;
    Color textColor = isOperator(buttonText) ? Colors.white : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(fontSize: 24, color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  bool isOperator(String text) {
    return text == '/' || text == '*' || text == '-' || text == '+' || text == '=' || text == '%' || text == 'C' || text == '⌫';
  }
}
