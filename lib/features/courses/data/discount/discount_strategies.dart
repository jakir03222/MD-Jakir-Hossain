import 'i_discount_strategy.dart';

class FixedAmountDiscountStrategy implements IDiscountStrategy {
  @override
  num calculate({required num price, required num discountAmount}) {
    final value = price - discountAmount;
    return value < 0 ? 0 : value;
  }
}

class PercentageDiscountStrategy implements IDiscountStrategy {
  @override
  num calculate({required num price, required num discountAmount}) {
    final value = price - (price * discountAmount / 100);
    return value < 0 ? 0 : value;
  }
}
