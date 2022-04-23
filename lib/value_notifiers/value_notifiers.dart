import 'package:flutter/material.dart';

ValueNotifier<bool> drawing = ValueNotifier(false);
ValueNotifier<List<Offset>> frame = ValueNotifier([]);
ValueNotifier<bool> videoUploaded = ValueNotifier(false);
