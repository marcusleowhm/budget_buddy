import 'package:flutter/material.dart';

List<dynamic> standardKeys = [
  '7',
  '8',
  '9',
  const Icon(Icons.backspace),
  '4',
  '5',
  '6',
  '-/+',
  '1',
  '2',
  '3',
  const Icon(Icons.done)
];

List<String> smallNominalKeys = [
  '0',
  '00',
  '.',
  'CE'
];


class Keyset {
  List<dynamic> keys = [];
}

class USDKeySet extends Keyset {
  @override
  List<dynamic> get keys => [...standardKeys, ...smallNominalKeys];
}


Map<String, dynamic> currencyKeys = {
  'USD': USDKeySet()
};
