library clusteringManager;

import '../photo/photo.dart';
import 'clusteringAlgorithm.dart';
import 'cluster.dart';
import 'defaultClusteringAlgorithm.dart';
import 'package:observe/observe.dart';
import 'singleLinkageStrategy.dart';

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
  
  List<String> cutTheTree(Cluster cluster, int numberOfSummaryPhotos, int numberOfPhotosImported){
    var selectedPhotos = new List<String>();
    //TODO caso 1 foto - random ou centro
    //TODO caso 2 fotos - Primeira divisão e  escolher uma foto de cada uma das duas
    //TODO caso numero fotos entre 3, inclusive e numero de fotos importadas - 1
    //TODO caso todas as fotos importadas - todos as leafs
    print("CUTTING THE TREE");
    print("FINAL CLUSTER: " + cluster.toString());
    print(cluster.getChildren().toString());
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
  
  List<Photo> doClustering(List<Photo> photos, int numberOfSummaryPhotos, int numberOfPhotosImported){
    var photoIds = new List<String>();
    var photosIdsToReturn = new List<String>();
    var photosToReturn = new List<Photo>();
    var photoDateInfo = new List<double>();
    var distances = null;
    for(Photo photo in photos){
      photoIds.add(photo.id);
      print("Photo ID: " + photo.id);
      photoDateInfo.add(photo.dataFromPhoto);
    }

    distances = calcDistances(photoDateInfo);
    print(distances.toString());

    ClusteringAlgorithm clusteringAlgorithm = new DefaultClusteringAlgorithm();
    clusterBuilt = clusteringAlgorithm.performClustering(distances, photoIds,
        new SingleLinkageStrategy());
    
    //TODO cut tree
    photosIdsToReturn = cutTheTree(clusterBuilt, numberOfSummaryPhotos, numberOfPhotosImported);
    
    //TODO choose photo object to return
    photosToReturn = IdForPhoto(photos, photosIdsToReturn);
        
    print("RETURNING FROM CLUSTERING");
    return photosToReturn;
  }
  
}