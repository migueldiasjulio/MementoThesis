library containerclass;

import 'dart:core';
import 'package:polymer/polymer.dart';
import 'Thumbnail.dart';
import 'dataBase.dart' as db;


//There's no multiple inheritance in Dart?? :/
class ContainerClass {
  
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);
  
}