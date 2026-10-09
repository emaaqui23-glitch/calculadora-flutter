enum OperationTypeEnum {
  add(symbol: '+'),
  subtract(symbol: '-'),
  multiply(symbol: 'x'),
  divide(symbol: '÷');

  final String symbol;
  const OperationTypeEnum({required this.symbol});
}
