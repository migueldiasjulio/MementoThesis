library containerclass;

import 'dart:core';
import 'package:polymer/polymer.dart';
import 'dart:html';

//There's no multiple inheritance in Dart?? :/
class ContainerClass {
  
  final List<ImageElement> thumbnailsSummary = toObservable([]);
  final List<ImageElement> thumbnailsStandBy = toObservable([]);
  final List<ImageElement> thumbnailsExcluded = toObservable([]);
  
}