double roundToNearestPositive(double value) {
  const double tenMillion = 10000000;
  const double fiveMillion = 5000000;
  const double million = 1000000;
  const double hundredThousand = 100000;
  const double tenThousand = 10000;
  const double fiveThousand = 5000;
  const double thousand = 1000;
  const double hundred = 100;
  const double fifty = 50;
  const double ten = 10;
  const double five = 5;

  if (value > tenMillion) {
    return ((value / fiveMillion).ceil() * fiveMillion);
  }

  if (value > fiveMillion) {
    return ((value / million).ceil() * million);
  }

  if (value > million) {
    return ((value / hundredThousand).ceil() * hundredThousand);
  }

  if (value > hundredThousand) {
    return ((value / tenThousand).ceil() * tenThousand);
  }

  if (value > tenThousand) {
    return ((value / fiveThousand).ceil() * fiveThousand);
  }

  if (value > thousand) {
    return ((value / hundred).ceil() * hundred);
  }

  if (value > hundred) {
    return ((value / fifty).ceil() * fifty);
  }

  if (value > fifty) {
    return ((value / ten).ceil() * ten);
  }

  if (value > ten) {
    return ((value / five).ceil() * five);
  }

  return ((value / 1).ceil() * 1);
}

double roundToNearestNegative(double value) {
  const double tenMillion = 10000000;
  const double fiveMillion = 5000000;
  const double million = 1000000;
  const double hundredThousand = 100000;
  const double tenThousand = 10000;
  const double fiveThousand = 5000;
  const double thousand = 1000;
  const double hundred = 100;
  const double fifty = 50;
  const double ten = 10;
  const double five = 5;

  //Convert to positive first
  value = value * -1;

  if (value > tenMillion) {
    return ((value / fiveMillion).ceil() * fiveMillion) * -1;
  }

  if (value > fiveMillion) {
    return ((value / million).ceil() * million) * -1;
  }

  if (value > million) {
    return ((value / hundredThousand).ceil() * hundredThousand) * -1;
  }

  if (value > hundredThousand) {
    return ((value / tenThousand).ceil() * tenThousand) * -1;
  }

  if (value > tenThousand) {
    return ((value / fiveThousand).ceil() * fiveThousand) * -1;
  }

  if (value > thousand) {
    return ((value / hundred).ceil() * hundred) * -1;
  }

  if (value > hundred) {
    return ((value / fifty).ceil() * fifty) * -1;
  }

  if (value > fifty) {
    return ((value / ten).ceil() * ten) * -1;
  }

  if (value > ten) {
    return ((value / five).ceil() * five) * -1;
  }

  return ((value / 1).ceil() * 1) * -1;
}
