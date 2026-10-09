import 'package:calculadora/enums/operation.type.dart';
import 'package:calculadora/widgets/button.widget.dart';
import 'package:flutter/material.dart';

import 'historic.page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayText;
  OperationTypeEnum? operationtype;
  late List<String> historic;

  @override
  void initState() {
    // quando a calculadora abrir, o visor deve começar mostrando 0.
    displayText = '0';
    historic = [];
    super.initState();
  }

  void setOperationType(OperationTypeEnum newType) {
    setState(() {
      operationtype = newType;

      // Permite colocar o sinal de negativo no começo de um número.
      if (newType == OperationTypeEnum.subtract &&
          (displayText == '0' || displayText.isEmpty)) {
        displayText = '-';
      } else {
        displayText += newType.symbol;
      }
    });
  }

  void clear() {
    setState(() {
      displayText = '0';
      operationtype = null;
    });
  }

  void appendNumber(String number) {
    setState(() {
      if (displayText == '0') {
        displayText = number;
      } else {
        displayText += number;
      }
    });
  }

  void deleteLastCharacter() {
    setState(() {
      if (displayText.length > 1) {
        displayText = displayText.substring(0, displayText.length - 1);
      } else {
        displayText = '0';
      }
    });
  }

  // Separa os números da expressão.
  // O "-" pode ser uma subtração OU o sinal de um número negativo.
  List<double> parseNumbers(String expression) {
    List<double> numbers = [];
    String currentNumber = '';

    for (int i = 0; i < expression.length; i++) {
      String character = expression[i];

      // Verifica se o "-" é sinal de um número negativo.
      bool isNegativeSign =
          character == '-' &&
          (i == 0 ||
              expression[i - 1] == '+' ||
              expression[i - 1] == 'x' ||
              expression[i - 1] == '÷');

      if (character == '+' ||
          character == 'x' ||
          character == '÷' ||
          (character == '-' && !isNegativeSign)) {
        if (currentNumber.isNotEmpty) {
          numbers.add(double.parse(currentNumber));
          currentNumber = '';
        }
      } else {
        currentNumber += character;
      }
    }

    // Adiciona o último número.
    if (currentNumber.isNotEmpty) {
      numbers.add(double.parse(currentNumber));
    }

    return numbers;
  }

  // Encontra somente os operadores da expressão.
  // Um "-" que seja sinal de número negativo não entra como operador.
  List<OperationTypeEnum> getOperators(String expression) {
    final operators = <OperationTypeEnum>[];

    for (int i = 0; i < expression.length; i++) {
      final character = expression[i];

      // Se o "-" estiver no começo ou depois de outro operador,
      // ele é sinal de número negativo e não uma subtração.
      if (character == '-' &&
          (i == 0 ||
              expression[i - 1] == '+' ||
              expression[i - 1] == 'x' ||
              expression[i - 1] == '÷')) {
        continue;
      }

      for (final operation in OperationTypeEnum.values) {
        if (operation.symbol == character) {
          operators.add(operation);
          break;
        }
      }
    }

    return operators;
  }

  double resolvePriorityOpertations(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;

    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.multiply) {
        numbers[index] = numbers[index] * numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationTypeEnum.divide) {
        numbers[index] = numbers[index] / numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }

    return numbers[0];
  }

  double resolveadditionAndSubtraction(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;

    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.add) {
        numbers[index] = numbers[index] + numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationTypeEnum.subtract) {
        numbers[index] = numbers[index] - numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }

    return numbers[0];
  }

  void calculate() {
    String expression = displayText.replaceAll(',', '.');

    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);

    resolvePriorityOpertations(numbers, operations);

    final result = resolveadditionAndSubtraction(numbers, operations);

    setState(() {
      displayText = result % 1 == 0
          ? result.toInt().toString()
          : result.toString().replaceAll('.', ',');

      historic.add('$expression = $displayText');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 227, 230),
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricPage(historic: historic),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 190,
            width: double.maxFinite,
            color: const Color.fromARGB(255, 214, 209, 213),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),

          SizedBox(height: 30),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ButtonWidget(
                    text: "C",
                    onPressed: () {
                      clear();
                    },
                    backgroundColor: const Color.fromARGB(255, 145, 195, 233),
                  ),
                  ButtonWidget(
                    text: "\u232B",
                    onPressed: () {
                      deleteLastCharacter();
                    },
                    backgroundColor: const Color.fromARGB(255, 107, 162, 243),
                    TextColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  ButtonWidget(
                    text: "÷",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.divide);
                    },
                    backgroundColor: const Color.fromARGB(255, 72, 159, 230),
                    TextColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),

              Row(
                children: [
                  ButtonWidget(
                    text: "7",
                    onPressed: () {
                      appendNumber("7");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "8",
                    onPressed: () {
                      appendNumber("8");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "9",
                    onPressed: () {
                      appendNumber("9");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "x",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.multiply);
                    },
                    backgroundColor: const Color.fromARGB(255, 72, 159, 230),
                    TextColor: const Color.fromARGB(255, 243, 246, 243),
                  ),
                ],
              ),

              Row(
                children: [
                  ButtonWidget(
                    text: "4",
                    onPressed: () {
                      appendNumber("4");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "5",
                    onPressed: () {
                      appendNumber("5");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "6",
                    onPressed: () {
                      appendNumber("6");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "-",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.subtract);
                    },
                    backgroundColor: const Color.fromARGB(255, 72, 159, 230),
                    TextColor: const Color.fromARGB(255, 239, 238, 238),
                  ),
                ],
              ),

              Row(
                children: [
                  ButtonWidget(
                    text: "1",
                    onPressed: () {
                      appendNumber("1");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "2",
                    onPressed: () {
                      appendNumber("2");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "3",
                    onPressed: () {
                      appendNumber("3");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "+",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.add);
                    },
                    backgroundColor: const Color.fromARGB(255, 72, 159, 230),
                    TextColor: const Color.fromARGB(255, 247, 249, 248),
                  ),
                ],
              ),

              Row(
                children: [
                  ButtonWidget(
                    text: "0",
                    onPressed: () {
                      appendNumber("0");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: ",",
                    onPressed: () {
                      appendNumber(",");
                    },
                    backgroundColor: const Color.fromARGB(255, 146, 164, 164),
                  ),
                  ButtonWidget(
                    text: "=",
                    onPressed: () {
                      calculate();
                    },
                    backgroundColor: const Color.fromARGB(255, 127, 180, 237),
                    TextColor: const Color.fromARGB(255, 244, 242, 242),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
