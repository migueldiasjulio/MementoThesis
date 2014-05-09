library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;

/**
 * TODO
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.Screen {


  static const String TAG = "big-size-photo";
  String title = "Big Size Photo",
         description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  String photoToDisplay;
  Element _name;


  BigSizePhoto.created() : super.created(){
    _name = $['name'];
  }

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
   }
  /**
   * TODO
   */
  @override
  void enteredView() {
    checkWhatPhotoToDisplay();
    super.enteredView();
  }

  void checkWhatPhotoToDisplay(){
    this.photoToDisplay = this.myDataBase.givephotoName;
    _name.text = this.photoToDisplay;
  }

  /**
   * TODO
   */
  home(_) {}


}