library clusteringManager;

import '../photo/photo.dart';
import 'clusteringAlgorithm.dart';
import 'cluster.dart';
import 'defaultClusteringAlgorithm.dart';
import 'package:observe/observe.dart';
import 'averageLinkageStrategy.dart';

class ClusteringManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static ClusteringManager _instance; 
  Cluster clusterBuilt = null;

  ClusteringManager._() {
    //TODO
  }

  static ClusteringManager get() {
    if (_instance == null) {
      _instance = new ClusteringManager._();
    }
    return _instance;
  }
  
  List<List<double>> calcDistances(List<double> photosDateInfo){
    var distances = new List<List<double>>();
    var size = photosDateInfo.length;
    var distance = 0.0;
    var listOfDistances = new List<double>();
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        distance = (photosDateInfo.elementAt(j) - photosDateInfo.elementAt(i)).abs();
        listOfDistances.add(distance);     
      }
      distances.insert(i, listOfDistances);
      listOfDistances = new List<double>();
    }
    
    return distances;
  }
  
  List<String> cutTheTree(Cluster cluster, int numberOfSummaryPhotos){
    var selectedPhotos = new List<String>();
    print("CUTTING THE TREE");
    return selectedPhotos;
  }
  
  List<Photo> IdForPhoto(List<Photo> photos, List<String> photosIdsToReturn){
    var photosToReturn = new List<Photo>();
    for(Photo photo in photos){
      for(String photoId in photosIdsToReturn){
        if(photo.id == photoId){
          photosToReturn.add(photo);
        }
      }
    }
    
    return photosToReturn;
  }
  
  List<Photo> doClustering(List<Photo> photos, int numberOfSummaryPhotos){
    var photoIds = new List<String>();
    var photosIdsToReturn = new List<String>();
    var photosToReturn = new List<Photo>();
    var photoDateInfo = new List<double>();
    var distances = null;
    for(Photo photo in photos){
      photoIds.add(photo.id);
      photoDateInfo.add(photo.dataFromPhoto);
    }

    distances = calcDistances(photoDateInfo);
    print(distances.toString());

    ClusteringAlgorithm clusteringAlgorithm = new DefaultClusteringAlgorithm();
    clusterBuilt = clusteringAlgorithm.performClustering(distances, photoIds,
        new AverageLinkageStrategy());
    
    //TODO cut tree
    photosIdsToReturn = cutTheTree(clusterBuilt, numberOfSummaryPhotos);
    
    //TODO choose photo object to return
    photosToReturn = IdForPhoto(photos, photosIdsToReturn);
        
    print("RETURNING FROM CLUSTERING");
    return photosToReturn;
  }
  
}