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
 var auxiliar = new List<Cluster>();

 ManipulationOverClusters._() {}

 static ManipulationOverClusters get() {
   if (_instance == null){
     _instance = new ManipulationOverClusters._();
   }
   return _instance;
 }
 
 void cleanAuxiliar() => auxiliar.clear();
 
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
 
 List<String> clustersToPhotosId(List<Cluster> clusters){
   var namesToReturn = new List<String>();
   
   clusters.forEach((cluster){
     namesToReturn.add(cluster.name);
   });
   
   return namesToReturn;
 }
 
   void returnAllLeafsFromThisCluster(Cluster cluster) {
     //Caso básico
     if (cluster.isLeaf()) auxiliar.add(cluster); 
     else {
       returnAllLeafsFromThisCluster(cluster.children[0]);
       returnAllLeafsFromThisCluster(cluster.children[1]);
     }
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