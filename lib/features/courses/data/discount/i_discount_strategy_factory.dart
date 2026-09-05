import 'discount_strategies.dart';
import 'i_discount_strategy.dart';

/// Factory so new discount types can be added without changing callers (OCP).
abstract class IDiscountStrategyFactory {
  IDiscountStrategy create(int discountType);
}

class DiscountStrategyFactory implements IDiscountStrategyFactory {
  @override
  IDiscountStrategy create(int discountType) {
    switch (discountType) {
      case 2:
        return PercentageDiscountStrategy();
      case 1:
      default:
        return FixedAmountDiscountStrategy();
    }
  }
}
