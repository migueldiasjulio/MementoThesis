library clusteringManager;

import '../photo/photo.dart';
import 'clusteringAlgorithm.dart';
import 'cluster.dart';
import 'defaultClusteringAlgorithm.dart';
import 'package:observe/observe.dart';
import 'singleLinkageStrategy.dart';
import 'dart:math';

class ClusteringManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static ClusteringManager _instance; 
  Cluster clusterBuilt = null;
  List<Cluster> auxiliar = null;

  ClusteringManager._() {
    auxiliar = new List<Cluster>();
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
  
  void returnAllLeafs(Cluster cluster){    
    //Caso básico
    if(cluster.isLeaf()) auxiliar.add(cluster);
    else{
      returnAllLeafs(cluster.children[0]);
      returnAllLeafs(cluster.children[1]);
    }     
  }
  
  Cluster chooseRandomly(Cluster cluster){   
    var random = new Random();
    auxiliar.clear();
    returnAllLeafs(cluster);
    var indexOfTheChoosenOne = random.nextInt(auxiliar.length);
    return auxiliar.elementAt(indexOfTheChoosenOne);
  }
  
  Cluster chooseForTheBest(Cluster cluster){
    //TODO
    return new Cluster("");
  }
  
  List<String> cutTheTree(Cluster cluster, int numberOfSummaryPhotos, int numberOfPhotosImported){
    var selectedPhotos = new List<String>();
    
    //Just 1 Photo case
    if(numberOfSummaryPhotos == 1){
      selectedPhotos.add(chooseRandomly(cluster).name);  
      auxiliar.clear();
    }
    else if(numberOfSummaryPhotos == 2){
      var children = cluster.getChildren();
      selectedPhotos.add(chooseRandomly(children.elementAt(0)).name);
      auxiliar.clear();
      selectedPhotos.add(chooseRandomly(children.elementAt(1)).name); 
      auxiliar.clear();
    }
    else{
      auxiliar.addAll(specialCaseCuttingTree(cluster, numberOfSummaryPhotos, new List<Cluster>()));
      var clustersAux = new List<Cluster>();
      clustersAux.addAll(auxiliar);
      selectedPhotos.addAll(specialChoose(clustersAux, numberOfSummaryPhotos));
      auxiliar.clear();  
    }
    print("Selected Photos: " + selectedPhotos.toString());
    return selectedPhotos;
  }
  
  List<String> specialChoose(List<Cluster> clusters, int numberOfSummaryPhotos){
    var photosToReturn = new List<Cluster>();
    var photoNames = new List<String>();
    
    for(Cluster cluster in clusters){
      if(photosToReturn.length != numberOfSummaryPhotos){
        
        var firstChild = chooseRandomly(cluster);
        photosToReturn.add(firstChild);
        
        if(photosToReturn.length != numberOfSummaryPhotos){
          var secondChild = chooseRandomly(cluster);
          while(secondChild == firstChild){
            secondChild = chooseRandomly(cluster);
          }
          auxiliar.clear(); 
          photosToReturn.add(secondChild); 
        }else{
          break;
        }
        
      }else{
        break;
      }
    }
    
    for(Cluster cluster in photosToReturn){
      photoNames.add(cluster.name);
    }
    
    return photoNames;
  }
  
  List<Cluster> specialCaseCuttingTree(Cluster cluster, int numberOfSummaryPhotos, List<Cluster> listToReturn){
    var goal = numberOfSummaryPhotos/2;
    goal = goal.round();
    var numberOfClusters = 2;
    var clusters = new List<Cluster>();
    clusters.add(cluster.children.elementAt(0));
    clusters.add(cluster.children.elementAt(1));
    
    //Andar para baixo na árvore até o número de leafs ser igual numberOfSummaryPhotos
    while(numberOfClusters != goal){
      cutAndAddTheBiggest(clusters);
      numberOfClusters = clusters.length;
    }
    listToReturn.addAll(clusters);
    
    return listToReturn;
  }
  
  void cutAndAddTheBiggest(List<Cluster> clusters){
    var biggest = returnBiggestCluster(clusters);
    var newClusterOne = biggest.getChildren().elementAt(0);
    var newClusterTwo = biggest.getChildren().elementAt(1);
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
    auxiliar.clear();
    
    if(numberOfSummaryPhotos == numberOfPhotosImported){
      photosToReturn.addAll(photos);
    }
    else{
    
      for(Photo photo in photos){
        photoIds.add(photo.id);
        photoDateInfo.add(photo.dataFromPhoto);
      }
  
      distances = calcDistances(photoDateInfo);
      ClusteringAlgorithm clusteringAlgorithm = new DefaultClusteringAlgorithm();
      print("A iniciar o clustering");
      clusterBuilt = clusteringAlgorithm.performClustering(distances, photoIds,
          new SingleLinkageStrategy());
      print("Clustering concluido");
      print("Cutting the tree");
      //TODO cut tree
      photosIdsToReturn = cutTheTree(clusterBuilt, numberOfSummaryPhotos, numberOfPhotosImported);
      print("Cut done!");
      
      //TODO choose photo object to return
      photosToReturn = IdForPhoto(photos, photosIdsToReturn);
    }
    
    return photosToReturn;
  } 
}