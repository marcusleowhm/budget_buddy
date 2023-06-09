double roundToNearestPositive(double value) {
  const double million = 1000000;
  const double hundredThousand = 100000;
  const double thousand = 1000;
  const double hundred = 100;
  const double fifty = 50;
  const double ten = 10;
  const double five = 5;

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

  if (value > fifty) {
    return ((value / fifty).ceil() * fifty);
  }

  if (value > ten) {
    return ((value / ten).ceil() * ten);
  }

  return ((value / five).ceil() * five);
}

double roundToNearestNegative(double value) {
  const double million = 1000000;
  const double hundredThousand = 100000;
  const double thousand = 1000;
  const double hundred = 100;
  const double fifty = 50;
  const double ten = 10;
  const double five = 5;

  //Convert to positive first
  value = value * -1;

  if (value > million) {
    return ((value / million).ceil() * million) * -1;
  }

  if (value > hundredThousand) {
    return ((value / hundredThousand).ceil() * hundredThousand) * -1;
  }

  if (value > thousand) {
    return ((value / thousand).ceil() * thousand) * -1;
  }

  if (value > hundred) {
    return ((value / hundred).ceil() * hundred) * -1;
  }

  if (value > fifty) {
    return ((value / fifty).ceil() * fifty) * -1;
  }

  if (value > ten) {
    return ((value / ten).ceil() * ten) * -1;
  }

  return ((value / five).ceil() * five) * -1;
}
