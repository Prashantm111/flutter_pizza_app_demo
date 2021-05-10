class PizzaSizeState {
  final PizzaSizeValue value;
  final double factor;

  PizzaSizeState(this.value) : this.factor = _getFactorSize(value);

  static double _getFactorSize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.70;
        break;
      case PizzaSizeValue.m:
        return 0.83;
        break;
      case PizzaSizeValue.l:
        return 1.0;
        break;
    }
    return  0.8;
  }

    int getPizzaPrice() {
    switch (value) {
      case PizzaSizeValue.s:
        return 15;
        break;
      case PizzaSizeValue.m:
        return 25;
        break;
      case PizzaSizeValue.l:
        return 35;
        break;
    }
    return 25;
  }
}

enum PizzaSizeValue {
  s,
  m,
  l,
}
