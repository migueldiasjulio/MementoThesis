library qtclusteringmanager;

import '../photo/photo.dart';
//import 'cluster.dart';
import '../photo/similarGroupOfPhotos.dart';
import 'package:observe/observe.dart';
import 'dart:math';
import 'cluster.dart';

class QTClusteringManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static QTClusteringManager _instance; 
  final double _thresholdDistance = 50.0;
  final double _samePhotoDistance = 0.0;

  QTClusteringManager._() {}

  static QTClusteringManager get() {
    if (_instance == null) {
      _instance = new QTClusteringManager._();
    }
    return _instance;
  }
  
  Photo chooseRandomly(SimilarGroupOfPhotos similarGroup){   
    var random = new Random(),
    indexOfTheChoosenOne = random.nextInt(similarGroup.giveMeAllPhotos.length);
    return similarGroup.giveMeAllPhotos.elementAt(indexOfTheChoosenOne);
  }
  
  List<Cluster> doClustering(List<Photo> allPhotos, List<List<double>> distanceMatrix){
    var returnList = new List<Cluster>(),
        allClusters = new List<Cluster>(),
        cluster = null;
    
    //Every Photo is a Cluster now
    var allPhotosSize = allPhotos.length;
    for(int i = 0; i < allPhotosSize; i++){
      cluster = new Cluster(allPhotos.elementAt(i), i);
      allClusters.add(cluster);
    }
    
    //Basic case
    if(allClusters.length <= 1){
      returnList.add(allClusters.first);
    }else{
      
      var size = allClusters.length;
      for(int i = 0; i < size; i++){
        var flag = true,
            nearestElement = 0;
        while(flag && (allClusters.elementAt(i).allPhotosFromCluster.length != allPhotos.length)){
          nearestElement = calcNearestElement(i, allPhotos, allClusters, distanceMatrix);
          if(distanceMatrix.elementAt(i).elementAt(nearestElement) > _thresholdDistance){
            
          }else{
            
          }
        }
        
      }
      
    }//else
    
    return returnList;    
  }
  
  int calcNearestElement(int i, List<Photo> allPhotos, List<Cluster> allClusters,
                             List<List<double>> distanceMatrix){
    var cluster = 0,
        imthisOne = allClusters.elementAt(i),
        myDistances = distanceMatrix.elementAt(i),
        myDistancesSize = myDistances.length;
    
    var indexsAlreadyTaken = allClusters.elementAt(i).indexsAlreadyTaken;
    int indexElement = calcSmallestDistanceOf(myDistances, indexsAlreadyTaken);
    //TODO
    
    return cluster;
  }
  
  int calcSmallestDistanceOf(List<double> distances, List<int> indexsAlreadyTaken){
    var indexToReturn;
    
    return indexToReturn;
  }
  
  
}