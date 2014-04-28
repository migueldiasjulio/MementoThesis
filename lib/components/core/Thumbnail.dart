library thumbnail;

/// A [Thumbnail] model
class Thumbnail {
  String src, title;
  int width, height;

  Thumbnail(this.src, {this.title, this.width: 140, this.height: 140});
}