/// Strategy contract for discount calculation (Open/Closed).
abstract class IDiscountStrategy {
  num calculate({required num price, required num discountAmount});
}
