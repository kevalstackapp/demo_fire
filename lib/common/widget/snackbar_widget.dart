import 'package:flutter/material.dart';

AppSnackBar(BuildContext context, {String? text}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text')));
}
