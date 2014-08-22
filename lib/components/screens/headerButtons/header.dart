import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
import '../../core/settings/mementoSettings.dart';

@CustomTag('help-element')
class HeaderElement extends PolymerElement {
  
  Modal help;
  Modal settings;
  Modal about;
  MementoSettings _settings = MementoSettings.get();
  
  HeaderElement.created() : super.created(){
    Modal.use();
    help = Modal.wire($['help']);
    help = Modal.wire($['settings']);
    help = Modal.wire($['about']);
    
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
  
  void defineFirstX(){
    _settings.setFunction("FIRSTX");
  }
  
  void defineRandom(){
    _settings.setFunction("RANDOM");
  }
  
  void defineHierarchical(){
    _settings.setFunction("HIERARCHICAL");
  }
  
  void showHelp(){
    help.show();
  }
  
  void showSettings(){
    settings.show();
  }
  
  void showAbout(){
    about.show();
  }
}