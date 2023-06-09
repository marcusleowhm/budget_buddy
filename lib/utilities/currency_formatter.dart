import 'package:intl/intl.dart';

final NumberFormat englishDisplayCurrencyFormatter = NumberFormat('###,##0.00');
final NumberFormat englishTypingCurrencyFormatter = NumberFormat('###,##0.##');
final NumberFormat compactCurrencyFormatter = NumberFormat.compact();
final NumberFormat indianCurrencyFormatter = NumberFormat('##,##,###');
final NumberFormat largeCurrencyFormatter = NumberFormat('###,###');

double roundToNearest(double value) {
  const double million = 1000000;
  const double hundredThousand = 100000;
  const double thousand = 1000;
  const double hundred = 100;
  const double fifty = 50;

  if (value > million) {
    return ((value / million).ceil() * million);
  }

  if (value > hundredThousand) {
    return ((value / hundredThousand).ceil() * hundredThousand);
  }

  if (value > thousand) {
    return ((value / thousand).ceil() * thousand);
  }

  if (value > hundred) {
    return ((value / hundred).ceil() * hundred);
  }

  return ((value / fifty).ceil() * fifty);

}