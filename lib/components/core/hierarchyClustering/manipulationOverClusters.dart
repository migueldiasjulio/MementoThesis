library manipulationoverclusters;

import 'package:observe/observe.dart';
import '../photo/photo.dart';
import 'cluster.dart';
import '../database/dataBase.dart';

class ManipulationOverClusters extends Object with Observable {
  
 /**
  * Singleton
  */
 static ManipulationOverClusters _instance; 

 ManipulationOverClusters._() {}

 static ManipulationOverClusters get() {
   if (_instance == null){
     _instance = new ManipulationOverClusters._();
   }
   return _instance;
 }
 
 void cutAndAddTheBiggest(List<Cluster> clusters){
   var biggest = returnBiggestCluster(clusters),
       newClusterOne = biggest.getChildren().elementAt(0),
       newClusterTwo = biggest.getChildren().elementAt(1);
   clusters.add(newClusterOne);
   clusters.add(newClusterTwo);
   clusters.remove(biggest);
 }
 
 int countLeafsInClusters(List<Cluster> clusters){
   var countLeafs = 0;
   for(Cluster cluster in clusters){
     countLeafs += cluster.countLeafs(0);
   }
   
   return countLeafs;
 }
 
 Cluster returnBiggestCluster(List<Cluster> clusters){
   var clusterReturn = clusters.first;
   for(Cluster cluster in clusters){
     if(cluster.countLeafs(0) > clusterReturn.countLeafs(0)){
       clusterReturn = cluster;
     }
   }
   
   return clusterReturn;
 }
 
 Photo clusterToPhoto(Cluster cluster){
   return DB.find(cluster.name);
 }
 
 List<Photo> clustersToPhotos(List<Cluster> clusters){
   var photosToReturn = new List<Photo>();
   
   clusters.forEach((cluster){
     photosToReturn.add(clusterToPhoto(cluster));
   });
   
   return photosToReturn;
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
 
}