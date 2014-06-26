library image;

import 'dart:html';

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

  Image createThumbnail(int width, int height, {String type: "image/png"}) {
    var canvas = new CanvasElement(width: width, height: height);
    var c2d = canvas.context2D;
    c2d.drawImageScaled(_img, 0, 0, width, height);
    return new Image(canvas.toDataUrl(type));
  }
}
