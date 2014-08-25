library clusteringManager;

import '../photo/photo.dart';
import 'clusteringAlgorithm.dart';
import 'cluster.dart';
import 'defaultClusteringAlgorithm.dart';
import 'package:observe/observe.dart';
import 'singleLinkageStrategy.dart';
import 'dart:math';
import '../histogram/histogramManager.dart';
import '../database/dataBase.dart';
import '../descriptor/mathWithDescriptor.dart';
import 'manipulationOverClusters.dart';

final _HistogramManager = HistogramManager.get();
final _MathWithDescriptor = MathWithDescriptor.get();
final _ManipulationOverClusters = ManipulationOverClusters.get();

class ClusteringManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static ClusteringManager _instance; 
  Cluster clusterBuilt = null;
  List<Cluster> auxiliar = null;
  List<Cluster> secondAuxiliar = null;

  ClusteringManager._() {
    auxiliar = new List<Cluster>();
  }

  static ClusteringManager get() {
    if (_instance == null) {
      _instance = new ClusteringManager._();
    }
    return _instance;
  }
  
  void returnAllLeafs(Cluster cluster, 
                      bool specialCase){    
    //Caso básico
      if(cluster.isLeaf()) auxiliar.add(cluster);
      else{
        returnAllLeafs(cluster.children[0], false);
        returnAllLeafs(cluster.children[1], false);
      }    
  }
  
  Cluster chooseRandomly(Cluster cluster){   
    var random = new Random();
    auxiliar.clear();
    returnAllLeafs(cluster, false);
    var indexOfTheChoosenOne = random.nextInt(auxiliar.length);
    return auxiliar.elementAt(indexOfTheChoosenOne);
  }
  
  Cluster chooseRandomlyFromList(List<Cluster> clusters){   
    var random = new Random();
    var indexOfTheChoosenOne = random.nextInt(clusters.length);
    return clusters.elementAt(indexOfTheChoosenOne);
  }
  
  Cluster chooseForTheBest(Cluster cluster){
    auxiliar.clear();
    returnAllLeafs(cluster, false);
    
    var listOfPhotos = _ManipulationOverClusters.clustersToPhotos(auxiliar);
    print("ListOfPhotos: " + listOfPhotos.length.toString());
    
    var aux = _HistogramManager.returnPhotoWithBestExposureLevel(listOfPhotos);
    print("Best choosed: " + aux.toString());
    var clusterToReturn = null;
    var childrens = cluster.children;
    
    auxiliar.forEach((child){
     if(child.name == aux.id){
       clusterToReturn = child;
     }
    });
    
    return clusterToReturn;
  }
  
  
  List<String> cutTheTree(Cluster cluster,
                          int numberOfSummaryPhotos, 
                          int numberOfPhotosImported){
    var selectedPhotos = new List<String>();
    
    //Just 1 Photo case
    if(numberOfSummaryPhotos == 1){
      selectedPhotos.add(chooseForTheBest(cluster).name);  
      auxiliar.clear();
    }
    //2 Photos case
    else if(numberOfSummaryPhotos == 2){
      var children = cluster.getChildren();
      selectedPhotos.add(chooseForTheBest(children.elementAt(0)).name);
      auxiliar.clear();
      selectedPhotos.add(chooseForTheBest(children.elementAt(1)).name); 
      auxiliar.clear();
    }
    else{
      //more than 2 and < total number of photos loaded
      auxiliar.addAll(specialCaseCuttingTree(cluster, numberOfSummaryPhotos, new List<Cluster>()));
      var clustersAux = new List<Cluster>();
      clustersAux.addAll(auxiliar);
      selectedPhotos.addAll(specialChoose(clustersAux, numberOfSummaryPhotos));
      auxiliar.clear();  
    }
    
    print("Selected Photos: " + selectedPhotos.toString());
    return selectedPhotos;
  }
  
  bool isSimilarToPreviousChoosed(Cluster clusterChoosed, 
                                  List<Cluster> photosToReturn){
    var photoChoosed = _ManipulationOverClusters.clusterToPhoto(clusterChoosed),
        photosAlreadyChoosed = _ManipulationOverClusters.clustersToPhotos(photosToReturn);
    
    photosAlreadyChoosed.forEach((photoAlreadyChoosed){
      if(photoChoosed.almostTheSamePhoto.contains(photoAlreadyChoosed)) { return true; }
    });
    
    return false;
  }
  
  bool isSimilarToOthersInCluster(Cluster clusterChoosed, 
                                  List<Cluster> restOfCluster){
    var valueToReturn = false;
    
    if(restOfCluster.length == 0){
      return false;
    }else{
 
      var photoChoosed = _ManipulationOverClusters.clusterToPhoto(clusterChoosed),   
          otherPhotos = _ManipulationOverClusters.clustersToPhotos(secondAuxiliar);
      
      otherPhotos.forEach((photo){
        if(photoChoosed.almostTheSamePhoto.contains(photo)) valueToReturn = true;
      });
    }
    
    return valueToReturn;
  }
  
  bool isNotTheLastOne(List<Cluster> clusters,
                       Cluster cluster) => cluster.equals(clusters.last);
  
  bool existSufficientPhotos(List<Cluster> photosToReturn, 
                             Cluster clusterChoosed, 
                             List<Cluster> listOfClusterWherePhotoExist, 
                             List<Cluster> restOfClusters,
                             int numberOfSummaryPhotos){ //In Cluster And Rest Of Clusters
    var returnValue = false,
        clusterWherePhotoExists = listOfClusterWherePhotoExist,
        photosToGo = (numberOfSummaryPhotos - photosToReturn.length);
    if(restOfClusters == null){
      clusterWherePhotoExists.remove(clusterChoosed);
      if(!isSimilarToOthersInCluster(clusterChoosed, clusterWherePhotoExists)){ 
        
        
        
        returnValue = true; }
    }else{
      if((!isSimilarToOthersInCluster(clusterChoosed, clusterWherePhotoExists))
          && (!isSimilarToPreviousChoosed(clusterChoosed, photosToReturn))){ returnValue = true; }
    }
    
    return returnValue;
  }
  
  
  
  List<String> specialChoose(List<Cluster> clusters, 
                             int numberOfSummaryPhotos){
    var photosToReturn = new List<Cluster>(),
        photoNames = new List<String>(),
        index = 0,
        clusterAux = null;
    
    for(Cluster cluster in clusters){
      if(photosToReturn.length != numberOfSummaryPhotos){
        
        var firstChild = chooseRandomly(cluster),
            continueCycle = false;
        
        //If it is not the last cluster
        if(isNotTheLastOne(clusters, cluster)){
          var clustersToGo = clusters.getRange(index, (clusters.length-1)),
              list = clustersToGo.toList();
                
          while((isSimilarToPreviousChoosed(firstChild, photosToReturn)
              || isSimilarToOthersInCluster(firstChild, auxiliar))
              && existSufficientPhotos(photosToReturn, firstChild, auxiliar, list, numberOfSummaryPhotos)){ 
            if(auxiliar.length > 1){ //Se houverem fotos no cluster
              auxiliar.remove(firstChild);
              firstChild = chooseRandomlyFromList(auxiliar);
            }else{
              continueCycle = true;
              break;
            }
          }
          
          if(continueCycle){
            continueCycle = false;
            continue;
          }
          
        }else{
          
          while((isSimilarToPreviousChoosed(firstChild, photosToReturn)
                || isSimilarToOthersInCluster(firstChild, auxiliar))
                && existSufficientPhotos(photosToReturn, firstChild, auxiliar, null, numberOfSummaryPhotos)){ 
            auxiliar.remove(firstChild);
            firstChild = chooseRandomlyFromList(auxiliar);
          } 
        }
        auxiliar.clear(); 
        photosToReturn.add(firstChild);
        
        if(photosToReturn.length != numberOfSummaryPhotos){
          
          
          var secondChild = chooseRandomly(cluster);
              continueCycle = false;
              
              //If it is not the last cluster
              if(isNotTheLastOne(clusters, cluster)){
                var clustersToGo = clusters.getRange(index, (clusters.length-1)),
                    list = clustersToGo.toList();
                      
                while((isSimilarToPreviousChoosed(secondChild, photosToReturn)
                    || isSimilarToOthersInCluster(secondChild, auxiliar))
                    && existSufficientPhotos(photosToReturn, secondChild, auxiliar, list, numberOfSummaryPhotos)){ 
                  if(auxiliar.length > 1){ //Se houverem fotos no cluster
                    auxiliar.remove(secondChild);
                    secondChild = chooseRandomlyFromList(auxiliar);
                  }else{
                    continueCycle = true;
                    break;
                  }
                }
                
                if(continueCycle){
                  continueCycle = false;
                  continue;
                }
                
              }else{
                while((isSimilarToPreviousChoosed(secondChild, photosToReturn)
                      || isSimilarToOthersInCluster(secondChild, auxiliar))
                      && existSufficientPhotos(photosToReturn, secondChild, auxiliar, null, numberOfSummaryPhotos)){ 
                  auxiliar.remove(secondChild);
                  secondChild = chooseRandomlyFromList(auxiliar);
                } 
              }
              auxiliar.clear(); 
              photosToReturn.add(secondChild);
          
          
        }else{
          break;
        }
        
      }else{
        break;
      }
      
      index++;
    }
    
    //TODO put it on a function
    for(Cluster cluster in photosToReturn){
      photoNames.add(cluster.name);
    }
    
    return photoNames;
  }
  
  List<Cluster> specialCaseCuttingTree(Cluster cluster, int numberOfSummaryPhotos, List<Cluster> listToReturn){
    var goal = numberOfSummaryPhotos/2,
        numberOfClusters = 2,
        clusters = new List<Cluster>();
    goal = goal.round();
    clusters.add(cluster.children.elementAt(0));
    clusters.add(cluster.children.elementAt(1));
    
    //Andar para baixo na árvore até o número de leafs ser igual numberOfSummaryPhotos
    while(numberOfClusters != goal){
      _ManipulationOverClusters.cutAndAddTheBiggest(clusters);
      numberOfClusters = clusters.length;
    }
    listToReturn.addAll(clusters);
    
    return listToReturn;
  }
  
  List<Photo> doClustering(List<Photo> photos, int numberOfSummaryPhotos, int numberOfPhotosImported){
    var photoIds = new List<String>(),
        photosIdsToReturn = new List<String>(),
        photosToReturn = new List<Photo>(),
        photoDateInfo = new List<double>(),
        distances = null;
    auxiliar.clear();
    
    if(numberOfSummaryPhotos == numberOfPhotosImported){
      photosToReturn.addAll(photos);
    }
    else{
    
      for(Photo photo in photos){
        photoIds.add(photo.id);
        photoDateInfo.add(photo.dataFromPhoto);
      }
  
      distances = _MathWithDescriptor.calcDistances(photoDateInfo);
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
      photosToReturn = _ManipulationOverClusters.IdForPhoto(photos, photosIdsToReturn);
    }
    
    return photosToReturn;
  } 
}