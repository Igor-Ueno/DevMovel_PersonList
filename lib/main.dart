import 'package:devmovel_personlist/personviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'myapp.dart';

void main() {
  // runApp(const MyApp());
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PersonViewModel()),
        ],
        child: const MyApp(),
      )
  );
}
