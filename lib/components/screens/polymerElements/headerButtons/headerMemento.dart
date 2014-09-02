library headerButtons;

import 'package:polymer/polymer.dart';
import 'dart:core';
import 'dart:html';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../algorithmOptions.dart';
import '../../screenAdvisor.dart';
import '../../../core/settings/mementoSettings.dart';

@CustomTag('header-element')
class HeaderElement extends AlgorithmOptions {
  
  MementoSettings _settings = MementoSettings.get();
  final _ScreenAdvisor = ScreenAdvisor.get();
  Modal help, settings, about;
  @observable String screenName = "";
  @observable bool importPhotos = false;
  @observable bool summaryManipulation = false;
  @observable bool displayingPhoto = false;
  @observable bool mainPage = true;
  
  HeaderElement.created() : super.created(){
    Modal.use();
    help = Modal.wire($['help']);
    settings = Modal.wire($['settings']);
    about = Modal.wire($['about']);
    
    $['firstx']
        ..onClick.listen((e) {
        defineFirstX();
        });
    $['random']
        ..onClick.listen((e) {
        defineRandom();
            });
    $['hierachical']
        ..onClick.listen((e) {
        defineHierarchical();
            });
  }
  
  void setBools(bool defaultScreen, 
                bool importPhotos,
                bool summaryManipulation,
                bool displayingPhoto){
    mainPage = defaultScreen;
    this.importPhotos = importPhotos;
    this.summaryManipulation = summaryManipulation;
    this.displayingPhoto = displayingPhoto;
  }
  
  void setBoolOfScreen(String screenName){
    switch(screenName){
      case "Import Photos" :
        setBools(false, true, false, false);
        break;
      case "Summary Manipulation" : 
        setBools(false, false, true, false);
         break;
      case "Displaying Photo" : 
        setBools(false, false, false, true);
         break;
      default : 
        setBools(true, false, false, false);
        break;
    }
  }
  
  void showHelp(){
    screenName = _ScreenAdvisor.screenName;
    setBoolOfScreen(screenName);
    help.show();
  }
  
  void showSettings(){
    checkTheRightAlgorithm();
    settings.show();
  }
  
  void showAbout(){
    about.show();
  }
  
}