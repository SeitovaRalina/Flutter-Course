import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/app.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runZonedGuarded(
      () => runApp(
            DevicePreview(
              enabled: !kReleaseMode,
              builder: (context) => const CoffeeShopApp(),
            ),
          ), (error, stack) {
    log(error.toString(), name: 'App Error', stackTrace: stack);
  });
}
