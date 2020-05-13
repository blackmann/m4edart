class Amount {
  final double value;
  final String currency;

  Amount([this.value, this.currency = 'GHS'])
      : assert(currency != null),
        assert(value != null && value > 0);

  Map<String, dynamic> toMap() {
    return {'value': value, 'unit': currency};
  }
}
