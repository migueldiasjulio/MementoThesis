library thumbnail;

/// A [Thumbnail] model
class Thumbnail {
  String src, title;
  int width, height, dataBaseVersion;

  Thumbnail(this.src, {this.title, this.width: 140, this.height: 140, this.dataBaseVersion});
}