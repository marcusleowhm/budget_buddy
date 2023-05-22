import 'package:flutter/material.dart';

const String plusCharacter = '\u002b';
const String minusCharacter = '\u2212';
const String multiplyCharacter = '\u00d7';
const String divideCharacter = '\u00f7';
const String equalsCharacter = '\u003d';

List<String> numberKeys = [
  '7',
  '8',
  '9',
  '4',
  '5',
  '6',
  '1',
  '2',
  '3',
  '0',
  '00',
  '.'
];

List<dynamic> actionKeys = [const Icon(Icons.backspace)];

class Keyset {
  List<dynamic> keys = [];
}

//TODO Refactor and create a currency file to store all the different keysets
class USDKeySet extends Keyset {
  @override
  List<dynamic> get keys => [...numberKeys, '', '', ...actionKeys];
}
