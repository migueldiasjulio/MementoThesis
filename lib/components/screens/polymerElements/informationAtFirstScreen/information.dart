library information;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
import '../algorithmOptions.dart';
import '../../../core/settings/mementoSettings.dart';

@CustomTag(InformationButtons.TAG)
class InformationButtons extends AlgorithmOptions {
  
  static const String TAG = "information-buttons";
  factory InformationButtons() => new Element.tag(TAG);
  MementoSettings _settings = MementoSettings.get();
  Modal howToSummarize,
        changeAlgorithm;
  
  InformationButtons.created() : super.created(){
    Modal.use();
  }
  
  void showHowToSummarize(){
    if(howToSummarize == null) howToSummarize = Modal.wire($['howToSummarize']);
    
    howToSummarize.show();
  }
  
  void chooseAlgorithm(){
    if(changeAlgorithm == null) changeAlgorithm = Modal.wire($['changeAlgorithm']);
    
    changeAlgorithm.show();
  }
  
}