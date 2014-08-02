library qtcluster;

import '../photo/photo.dart';

class Cluster{
  
  List<Photo> _allPhotosFromCluster = new List<Photo>();
  double _raioMaximo = 0.0;
  List<int> _indexsAlreadyTaken = new List<int>();
  
  Cluster(Photo photo, int indexToAdd){
    _allPhotosFromCluster.add(photo);
    _indexsAlreadyTaken.add(indexToAdd);
  }
  
  void addToCluster(Photo photo, double distanceToNewElement, int indexToAdd){
    _allPhotosFromCluster.add(photo);
    _raioMaximo = distanceToNewElement;
    _indexsAlreadyTaken.add(indexToAdd);
  }
  
  List<Photo> get allPhotosFromCluster => _allPhotosFromCluster;
  List<int> get indexsAlreadyTaken => _indexsAlreadyTaken;
  double get raioMaximo => _raioMaximo;
}