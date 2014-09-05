library manipulationoverclusters;

import 'package:observe/observe.dart';
import '../photo/photo.dart';
import 'cluster.dart';
import '../database/dataBase.dart';

class ManipulationOverClusters extends Object with Observable {

  /**
  * ManipulationOverClusters variables
  */
  static ManipulationOverClusters _instance;
  var auxiliar = new List<Cluster>();

  ManipulationOverClusters._() {}

  static ManipulationOverClusters get() {
    if (_instance == null) {
      _instance = new ManipulationOverClusters._();
    }
    return _instance;
  }

  /**
  * 
  * Function the clean auxiliar variable
  * 
  */
  void cleanAuxiliar() => auxiliar.clear();

  /**
  * 
  * Function to cut the cluster and add the biggest one
  * 
  */
  void cutAndAddTheBiggest(List<Cluster> clusters) {
    var biggest = returnBiggestCluster(clusters),
        newClusterOne = biggest.getChildren().elementAt(0),
        newClusterTwo = biggest.getChildren().elementAt(1);
    clusters.add(newClusterOne);
    clusters.add(newClusterTwo);
    clusters.remove(biggest);
  }

  /**
  * 
  * Function to count the leafs inside clusters
  * 
  */
  int countLeafsInClusters(List<Cluster> clusters) {
    var countLeafs = 0;
    for (Cluster cluster in clusters) {
      countLeafs += cluster.countLeafs(0);
    }

    return countLeafs;
  }

  /**
  * 
  * Function to return the biggest cluster
  * 
  */
  Cluster returnBiggestCluster(List<Cluster> clusters) {
    var clusterReturn = clusters.first;
    for (Cluster cluster in clusters) {
      if (cluster.countLeafs(0) > clusterReturn.countLeafs(0)) {
        clusterReturn = cluster;
      }
    }

    return clusterReturn;
  }

  /**
  * 
  * Put a cluster as argument and receive a photo as response
  * 
  */
  Photo clusterToPhoto(Cluster cluster) {
    return DB.find(cluster.name);
  }

  /**
  * 
  * Put a list of clusters as argument and receive a list of photos as response
  * 
  */
  List<Photo> clustersToPhotos(List<Cluster> clusters) {
    var photosToReturn = new List<Photo>();

    clusters.forEach((cluster) {
      photosToReturn.add(clusterToPhoto(cluster));
    });

    return photosToReturn;
  }

  /**
  * 
  * Put a list of clusters as argument and receive a list containing the respective photo names as response
  * 
  */
  List<String> clustersToPhotosId(List<Cluster> clusters) {
    var namesToReturn = new List<String>();

    clusters.forEach((cluster) {
      namesToReturn.add(cluster.name);
    });

    return namesToReturn;
  }

  /**
  * 
  * Return all leafs inside a specific cluster
  * 
  */
  void returnAllLeafsFromThisCluster(Cluster cluster) {
    if (cluster.isLeaf()) auxiliar.add(cluster); else {
      returnAllLeafsFromThisCluster(cluster.children[0]);
      returnAllLeafsFromThisCluster(cluster.children[1]);
    }
  }

  /**
   * 
   * Receive a list of photos given a list of photo Ids
   * 
   */
  List<Photo> IdForPhoto(List<Photo> photos, List<String> photosIdsToReturn) {
    var photosToReturn = new List<Photo>();
    for (Photo photo in photos) {
      for (String photoId in photosIdsToReturn) {
        if (photo.id == photoId) {
          photosToReturn.add(photo);
        }
      }
    }

    return photosToReturn;
  }
  
}