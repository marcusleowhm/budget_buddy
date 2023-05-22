import 'package:flutter/material.dart';

const String plusCharacter = '\u002b';
const String minusCharacter = '\u2212';
const String multiplyCharacter = '\u00d7';
const String divideCharacter = '\u00f7';
const String equalsCharacter = '\u003d';

List<List<String>> numberKeys = [
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  ['0', '00', '.'],
];

List<List<dynamic>> actionKeys = [
    [
      const Icon(Icons.backspace)
    ]
  ];

class Keyset {

  List<List<dynamic>> keys = [];

}

//TODO Refactor and create a currency file to store all the different keysets
class USDKeySet extends Keyset {
  @override
  List<List<dynamic>> get keys => <List<dynamic>>[
        ['', '', ...actionKeys[0]],
        [...numberKeys[0],],
        [...numberKeys[1],],
        [...numberKeys[2],],
        [...numberKeys[3],],
      ];
}
