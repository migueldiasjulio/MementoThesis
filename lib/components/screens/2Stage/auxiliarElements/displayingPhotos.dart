library displayingphotos;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../core/photo/photo.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import '../summaryManipulationAuxiliar.dart';

final _summaryManipulationAuxiliar = SummaryManipulationAuxiliar.get();

@CustomTag('displaying-photos')
class DisplayingPhotos extends PolymerElement {
  
  DisplayingPhotos.created() : super.created(){}
  
}