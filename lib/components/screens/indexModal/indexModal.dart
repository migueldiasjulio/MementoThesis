library indexmodal;

import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';

/**
 * Index Modal dart
 */
@CustomTag('index-modal')
class IndexModal extends PolymerElement {

  Modal help;
  Modal settings;
  Modal about;
  
  /**
   * TODO
   */
  IndexModal.created() : super.created() {
    Modal.use();
    help = Modal.wire($['help']);
    settings = Modal.wire($['settings']);
    about = Modal.wire($['about']);
  }
  
  
  void showHelp(){
    help.show();
  }

}