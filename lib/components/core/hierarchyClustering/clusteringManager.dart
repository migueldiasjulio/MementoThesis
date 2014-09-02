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

  void returnAllLeafs(Cluster cluster, bool specialCase) {
    //Caso básico
    if (cluster.isLeaf()) auxiliar.add(cluster); else {
      returnAllLeafs(cluster.children[0], false);
      returnAllLeafs(cluster.children[1], false);
    }
  }

  Cluster chooseRandomly(Cluster cluster) {
    var random = new Random();
    auxiliar.clear();
    returnAllLeafs(cluster, false);
    var indexOfTheChoosenOne = random.nextInt(auxiliar.length);
    return auxiliar.elementAt(indexOfTheChoosenOne);
  }

  Cluster chooseRandomlyFromList(List<Cluster> clusters) {
    var random = new Random();
    var indexOfTheChoosenOne = random.nextInt(clusters.length);
    return clusters.elementAt(indexOfTheChoosenOne);
  }

  Cluster chooseForTheBest(Cluster cluster) {
    auxiliar.clear();
    returnAllLeafs(cluster, false);

    var listOfPhotos = _ManipulationOverClusters.clustersToPhotos(auxiliar);
    print("ListOfPhotos: " + listOfPhotos.length.toString());

    var aux = _HistogramManager.returnPhotoWithBestExposureLevel(listOfPhotos);
    print("Best choosed: " + aux.toString());
    var clusterToReturn = null;
    var childrens = cluster.children;

    auxiliar.forEach((child) {
      if (child.name == aux.id) {
        clusterToReturn = child;
      }
    });

    return clusterToReturn;
  }


  List<String> cutTheTree(Cluster cluster, int numberOfSummaryPhotos, int numberOfPhotosImported) {
    var selectedPhotos = new List<String>();

    //Just 1 Photo case
    if (numberOfSummaryPhotos == 1) {
      selectedPhotos.add(chooseForTheBest(cluster).name);
      auxiliar.clear();
    } //2 Photos case
    else if (numberOfSummaryPhotos == 2) {
      var children = cluster.getChildren();
      selectedPhotos.add(chooseForTheBest(children.elementAt(0)).name);
      auxiliar.clear();
      selectedPhotos.add(chooseForTheBest(children.elementAt(1)).name);
      auxiliar.clear();
    } else {
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

  bool isSimilarToPreviousChoosed(Cluster clusterChoosed, List<Cluster> photosToReturn) {
    print("--> INSIDE isSimilarToPreviousChoosed <--");
    var photoChoosed = _ManipulationOverClusters.clusterToPhoto(clusterChoosed),
        photosAlreadyChoosed = _ManipulationOverClusters.clustersToPhotos(photosToReturn);

    print("Photo Choosed: " + photoChoosed.title.toString());
    print("Number of Photos already choosed: " + photosAlreadyChoosed.length.toString());
    print("Vou percorrer as fotos ja selecionadas");
    photosAlreadyChoosed.forEach((photoAlreadyChoosed) {
      if (photoChoosed.almostTheSamePhoto.contains(photoAlreadyChoosed)) {
        print("E parecida a uma que ja foi escolhida");
        print("--> OUTSIDE isSimilarToPreviousChoosed <--");
        return true;
      }
    });
    print("--> OUTSIDE isSimilarToPreviousChoosed <--");
    return false;
  }

  bool isSimilarToOthersInCluster(Cluster clusterChoosed, List<Cluster> restOfCluster) {
    var valueToReturn = false;

    if (restOfCluster.length == 0) {
      return false;
    } else {
      var photoChoosed = _ManipulationOverClusters.clusterToPhoto(clusterChoosed),
          otherPhotos = _ManipulationOverClusters.clustersToPhotos(secondAuxiliar);

      otherPhotos.forEach((photo) {
        if (photoChoosed.almostTheSamePhoto.contains(photo)) valueToReturn = true;
      });
    }

    return valueToReturn;
  }

  bool isNotTheLastOne(List<Cluster> clusters, Cluster cluster) => cluster.equals(clusters.last);

  int doTheWork(int needAnotherOne, Cluster child, List<Cluster> photosToReturn, 
                List<Cluster> clustersToGo, bool firstChild) {
    var condition = 1;
    if(!firstChild){condition = 0;}
    var needAnotherOne = 0;
    if (isSimilarToPreviousChoosed(child, photosToReturn)) {
      var gotOne = false;
      print("E semelhante a outras ja selecionadas");
      while (auxiliar.length > condition) {
        print("Se houver mais do que uma foto depois de retirar a anterior");
        child = chooseRandomlyFromList(auxiliar);
        auxiliar.remove(child);
        if (!isSimilarToPreviousChoosed(child, photosToReturn)) {
          photosToReturn.add(child);
          gotOne = true;
          break;
        }
      }
      if (!gotOne) {
        print("Nao consegui nada neste cluster para este child");
        var numberOfPhotosToCollect = needAnotherOne+1;
        if(thereAreConditionToGetThePhotos(numberOfPhotosToCollect, clustersToGo)){
          print("Mas e possivel obter noutro cluster");
          needAnotherOne++;
        }else{
          photosToReturn.add(child); 
        }   
      }
    } else {
      photosToReturn.add(child);
    }
    return needAnotherOne;
  }
  
  bool thereAreConditionToGetThePhotos(int needAnotherOne, List<Cluster> clustersToGo){
    var numberOfPhotos = 0,
        clusterPhotos = 0,
        calculations = 0;
    
    clustersToGo.forEach((clusters){
      _ManipulationOverClusters.returnAllLeafsFromThisCluster(clusters);
      clusterPhotos = _ManipulationOverClusters.auxiliar.length;
      calculations = clusterPhotos - 2;
      numberOfPhotos += calculations;
      _ManipulationOverClusters.cleanAuxiliar();
    });
    
    return (numberOfPhotos >= needAnotherOne);
  }

  List<String> specialChoose(List<Cluster> clusters, int numberOfSummaryPhotos) {
    var photosToReturn = new List<Cluster>(),
        index = 0,
        needAnotherOne = 0,
        clustersToGo = null;

    print("<<<<<<<<<<<VAMOS COMECAR A ITERAR OS CLUSTERS>>>>>>>>>>");
    for (Cluster cluster in clusters) {
      var checkLater = false;
      print("------------Cluster number: " + index.toString() + "------------");
      if (photosToReturn.length != numberOfSummaryPhotos) {
        print("Ainda nao tenho todas as fotos");

         var aux = clusters.getRange((index+1), (clusters.length));
         clustersToGo = new List<Cluster>();
         clustersToGo.addAll(aux);
        if(needAnotherOne > 0){
          checkLater = true;
        }
        
        print("First Child");
        var firstChild = chooseRandomly(cluster);
        auxiliar.remove(firstChild);
        needAnotherOne += doTheWork(needAnotherOne, firstChild, photosToReturn, clustersToGo, true);
        print("First Child!");

        print("Second Child");
        var secondChild = chooseRandomlyFromList(auxiliar);
        auxiliar.remove(secondChild);
        needAnotherOne += doTheWork(needAnotherOne, secondChild, photosToReturn, clustersToGo, false);
        print("Second Child!");
        
        if(checkLater && auxiliar.isNotEmpty){
          var cycle = true,
              anotherChild = null;
          anotherChild = chooseRandomlyFromList(auxiliar);
          auxiliar.remove(anotherChild);
          photosToReturn.add(anotherChild);
          needAnotherOne--;
          while(cycle){
            if(!thereAreConditionToGetThePhotos(needAnotherOne, clustersToGo) && auxiliar.isNotEmpty){
              anotherChild = chooseRandomlyFromList(auxiliar);
              auxiliar.remove(anotherChild);
              photosToReturn.add(anotherChild);
              needAnotherOne--;
            }else{cycle = false;}
          }
        }
        
        auxiliar.clear();
      }
      index++;
    }
    print("<<<<<<<<<<<ITERACAO DOS CLUSTERS TERMINADA>>>>>>>>>>");

    return _ManipulationOverClusters.clustersToPhotosId(photosToReturn);
  }

  List<Cluster> specialCaseCuttingTree(Cluster cluster, int numberOfSummaryPhotos, List<Cluster> listToReturn) {
    var goal = numberOfSummaryPhotos / 2,
        numberOfClusters = 2,
        clusters = new List<Cluster>();
    goal = goal.round();
    clusters.add(cluster.children.elementAt(0));
    clusters.add(cluster.children.elementAt(1));

    //Andar para baixo na árvore até o número de leafs ser igual numberOfSummaryPhotos
    while (numberOfClusters != goal) {
      _ManipulationOverClusters.cutAndAddTheBiggest(clusters);
      numberOfClusters = clusters.length;
    }
    listToReturn.addAll(clusters);

    return listToReturn;
  }

  List<Photo> doClustering(List<Photo> photos, int numberOfSummaryPhotos, int numberOfPhotosImported) {
    var photoIds = new List<String>(),
        photosIdsToReturn = new List<String>(),
        photosToReturn = new List<Photo>(),
        photoDateInfo = new List<double>(),
        distances = null;
    auxiliar.clear();

    if (numberOfSummaryPhotos == numberOfPhotosImported) {
      photosToReturn.addAll(photos);
    } else {

      for (Photo photo in photos) {
        photoIds.add(photo.id);
        photoDateInfo.add(photo.dataFromPhoto);
      }

      distances = _MathWithDescriptor.calcDistances(photoDateInfo);
      ClusteringAlgorithm clusteringAlgorithm = new DefaultClusteringAlgorithm();
      print("A iniciar o clustering");
      clusterBuilt = clusteringAlgorithm.performClustering(distances, photoIds, new SingleLinkageStrategy());
      print("Clustering concluido");
      print("Cutting the tree");
      photosIdsToReturn = cutTheTree(clusterBuilt, numberOfSummaryPhotos, numberOfPhotosImported);
      print("Cut done!");
      photosToReturn = _ManipulationOverClusters.IdForPhoto(photos, photosIdsToReturn);
    }

    return photosToReturn;
  }
}
