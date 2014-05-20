library thumbnail;

/// A [Thumbnail] model
class Thumbnail {
  String src, title;
  int width, height;

  Thumbnail(this.src, {this.title, this.width: 256, this.height: 256});
  
}