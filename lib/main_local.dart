import 'package:budget_buddy/env.dart';
import 'package:budget_buddy/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  AppEnvironment.setupEnv(Environment.local);
  runApp(const MyApp());
}
