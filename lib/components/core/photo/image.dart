library image;

import 'dart:html';
import 'dart:math';

/// A custom [Image] model
class Image {
  ImageElement _img;

  Image(String src, {String title, int width, int height}) {
    _img = new ImageElement(src: src, width: width, height: height);

    if (title != null) { _img.title = title; }
  }

  String get src => _img.src;
  int get width => _img.width;
  int get height => _img.height;
  String get title => _img.title;
  ImageElement get image => _img;

  Image createThumbnail(int width, int height, {String type: "image/png"}) {
    var canvas = new CanvasElement(width: width, height: height);
    var c2d = canvas.context2D;
    c2d.drawImageScaled(_img, 0, 0, width, height);
    return new Image(canvas.toDataUrl(type));
  }
  
  Image createThumbnailToShow(bool isMini) {
    var type =  "image/png",
    maxwidth = 0,
    maxheight = 0;
    if(isMini){
      maxwidth = 135;
      maxheight = 135;
    }else{
      maxwidth = 200;
      maxheight = 200;
    }
    var ratio = min(maxwidth/width, maxheight/height);
    var widthThumb = width*ratio;
    var heightThumb = height*ratio;
    widthThumb = widthThumb.round();
    heightThumb = heightThumb.round();
    var canvas = new CanvasElement(width: widthThumb, height: heightThumb);
    var c2d = canvas.context2D;
    c2d.drawImageScaled(_img, 0, 0, widthThumb, heightThumb);
    return new Image(canvas.toDataUrl(type));
  }
}