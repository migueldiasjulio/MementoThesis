library information;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
import '../algorithmOptions.dart';
import '../../../core/settings/mementoSettings.dart';
import '../../defaultScreen/screenModule.dart' as screenmodule;

/*
 * 
 */ 
@CustomTag(InformationButtons.TAG)
class InformationButtons extends AlgorithmOptions {

  /*
   * 
   */
  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  static const String TAG = "information-buttons";
  factory InformationButtons() => new Element.tag(TAG);
  MementoSettings _settings = MementoSettings.get();
  Modal howToSummarize, changeAlgorithm;
  @published Router router;
  @published Map<String, screenmodule.ScreenModule> passingScreens;
  /*
   * 
   */ 
  InformationButtons.created() : super.created() {
    Modal.use();
  }

  /*
   * 
   */ 
  void showHowToSummarize() {
    if (howToSummarize == null) howToSummarize = Modal.wire($['howToSummarize']);
    howToSummarize.show();
  }
  
  /**
   * Navigate to the home of the selected module
   */
  void navigate(event, detail, target) {
    router.go('${target.dataset['target']}', {});
  }

  /*
   * 
   */ 
  void chooseAlgorithm() {
    $['firstx']..onClick.listen((e) {
          defineFirstX();
        });
    $['random']..onClick.listen((e) {
          defineRandom();
        });
    $['hierachical']..onClick.listen((e) {
          defineHierarchical();
        });
    
    checkTheRightAlgorithm();
    if (changeAlgorithm == null) changeAlgorithm = Modal.wire($['changeAlgorithm']);

    changeAlgorithm.show();
  }

}