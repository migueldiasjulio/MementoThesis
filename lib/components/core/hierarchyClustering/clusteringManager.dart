library clusteringManager;

import '../photo/photo.dart';
import 'clusteringAlgorithm.dart';
import 'cluster.dart';
import 'defaultClusteringAlgorithm.dart';
import 'package:observe/observe.dart';
import 'singleLinkageStrategy.dart';
import 'dart:math';
import '../histogram/histogramManager.dart';
import '../descriptor/mathWithDescriptor.dart';
import 'manipulationOverClusters.dart';

final _HistogramManager = HistogramManager.get();
final _MathWithDescriptor = MathWithDescriptor.get();
final _ManipulationOverClusters = ManipulationOverClusters.get();

class ClusteringManager extends Object with Observable {

  /**
   * ClusteringManager variables
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

  /**
   * 
   * Return All leafs inside some Cluster. iterative function
   * 
   */
  void returnAllLeafs(Cluster cluster) {
    //Caso básico
    if (cluster.isLeaf()) auxiliar.add(cluster); else {
      returnAllLeafs(cluster.children[0]);
      returnAllLeafs(cluster.children[1]);
    }
  }

  /**
   * 
   * Choose randomly a leaf inside a given cluster
   * 
   */
  Cluster chooseRandomly(Cluster cluster) {
    var random = new Random();
    auxiliar.clear();
    returnAllLeafs(cluster);
    var indexOfTheChoosenOne = random.nextInt(auxiliar.length);

    return auxiliar.elementAt(indexOfTheChoosenOne);
  }

  /**
   * 
   * Choose randomly a leaf inside a given list
   * 
   */
  Cluster chooseRandomlyFromList(List<Cluster> clusters) {
    var random = new Random();
    var indexOfTheChoosenOne = random.nextInt(clusters.length);

    return clusters.elementAt(indexOfTheChoosenOne);
  }

  /**
   * 
   * Choose for the best, looking to the histogram data, leaf inside a given cluster
   * 
   */
  Cluster chooseForTheBestFromList(List<Cluster> clusters) {
    var listOfPhotos = _ManipulationOverClusters.clustersToPhotos(clusters);
        print("Number of photos:" + listOfPhotos.length.toString());
        var photo = _HistogramManager.returnPhotoWithBestExposureLevel(listOfPhotos),
        clusterToReturn = null;

    clusters.forEach((child) {
      if (child.name == photo.id) {
        clusterToReturn = child;
        return clusterToReturn;
      }
    });

    return clusterToReturn;
  }

  /**
   * 
   * Choose for the best, looking to the histogram data, leaf inside a given cluster
   * 
   */
  Cluster chooseForTheBest(Cluster cluster) {
    auxiliar.clear();
    returnAllLeafs(cluster);

    return chooseForTheBestFromList(auxiliar);
  }

  /**
   * 
   * Function that cuts the clusters that have been created
   * 
   */
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

    //print("Selected Photos: " + selectedPhotos.toString());
    return selectedPhotos;
  }

  /**
   * 
   * Verifies if the choosen cluster is similar to previous clusters already choosed
   * 
   */
  bool isSimilarToPreviousChoosed(Cluster clusterChoosed, List<Cluster> photosToReturn) {
    var photoChoosed = _ManipulationOverClusters.clusterToPhoto(clusterChoosed),
        photosAlreadyChoosed = _ManipulationOverClusters.clustersToPhotos(photosToReturn);

    photosAlreadyChoosed.forEach((photoAlreadyChoosed) {
      if (photoChoosed.almostTheSamePhoto.contains(photoAlreadyChoosed)) {

        return true;
      }
    });

    return false;
  }

  /**
   * 
   * Verifies if the choosen cluster is similar to others in the same parent cluster
   * 
   */
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

  /**
   * 
   * Verifies if the choosen cluster is not the last cluster
   * 
   */
  bool isNotTheLastOne(List<Cluster> clusters, Cluster cluster) => cluster.equals(clusters.last);

  /**
   * 
   * Auxiliar function in the process of choosing the right photos 
   * 
   */
  int doTheWork(int needAnotherOne, Cluster child, 
                List<Cluster> photosToReturn, 
                List<Cluster> clustersToGo, bool firstChild) {
    var condition = 1;
    if (!firstChild) {
      condition = 0;
    }
    var needAnotherOne = 0;
    if (isSimilarToPreviousChoosed(child, photosToReturn)) {
      var gotOne = false;
      while (auxiliar.length > condition) {
        child = chooseForTheBestFromList(auxiliar);
        auxiliar.remove(child);
        if (!isSimilarToPreviousChoosed(child, photosToReturn)) {
          photosToReturn.add(child);
          gotOne = true;
          break;
        }
      }
      if (!gotOne) {
        var numberOfPhotosToCollect = needAnotherOne + 1;
        if (thereAreConditionToGetThePhotos(numberOfPhotosToCollect, clustersToGo)) {
          needAnotherOne++;
        } else {
          photosToReturn.add(child);
        }
      }
    } else {
      photosToReturn.add(child);
    }

    return needAnotherOne;
  }

  /**
   * 
   * Verifies if there are conditions to get the photos inside the next clusters
   * 
   */
  bool thereAreConditionToGetThePhotos(int needAnotherOne, List<Cluster> clustersToGo) {
    var numberOfPhotos = 0,
        clusterPhotos = 0,
        calculations = 0;

    clustersToGo.forEach((clusters) {
      _ManipulationOverClusters.returnAllLeafsFromThisCluster(clusters);
      clusterPhotos = _ManipulationOverClusters.auxiliar.length;
      calculations = clusterPhotos - 2;
      numberOfPhotos += calculations;
      _ManipulationOverClusters.cleanAuxiliar();
    });

    return (numberOfPhotos >= needAnotherOne);
  }

  /**
   * 
   * Function to choose the right photos to the semiautomatic summary
   * 
   */
  List<String> specialChoose(List<Cluster> clusters, int numberOfSummaryPhotos) {
    var photosToReturn = new List<Cluster>(),
        index = 0,
        needAnotherOne = 0,
        clustersToGo = null;

    for (Cluster cluster in clusters) {
      var checkLater = false;
      if (photosToReturn.length != numberOfSummaryPhotos) {
        var aux = clusters.getRange((index + 1), (clusters.length));
        clustersToGo = new List<Cluster>();
        clustersToGo.addAll(aux);
        if (needAnotherOne > 0) {
          checkLater = true;
        }

        if (photosToReturn.length != numberOfSummaryPhotos) {
          var firstChild = chooseForTheBest(cluster);
          auxiliar.remove(firstChild);
          needAnotherOne += doTheWork(needAnotherOne, firstChild, photosToReturn, clustersToGo, true);

          if (photosToReturn.length != numberOfSummaryPhotos) {
            var secondChild = chooseForTheBestFromList(auxiliar);
            auxiliar.remove(secondChild);
            needAnotherOne += doTheWork(needAnotherOne, secondChild, photosToReturn, clustersToGo, false);

            if (checkLater && auxiliar.isNotEmpty) {
              var cycle = true,
                  anotherChild = null;
              anotherChild = chooseForTheBestFromList(auxiliar);
              auxiliar.remove(anotherChild);
              photosToReturn.add(anotherChild);
              needAnotherOne--;
              while (cycle && (photosToReturn.length != numberOfSummaryPhotos)) {
                if (!thereAreConditionToGetThePhotos(needAnotherOne, clustersToGo) && auxiliar.isNotEmpty) {
                  anotherChild = chooseForTheBestFromList(auxiliar);
                  auxiliar.remove(anotherChild);
                  photosToReturn.add(anotherChild);
                  needAnotherOne--;
                } else {
                  cycle = false;
                }
              }
            }
          }
        }

        auxiliar.clear();
      }
      index++;
    }

    return _ManipulationOverClusters.clustersToPhotosId(photosToReturn);
  }

  /**
   * 
   * Cutting the built tree
   * 
   */
  List<Cluster> specialCaseCuttingTree(Cluster cluster, int numberOfSummaryPhotos, List<Cluster> listToReturn) {
    var goal = numberOfSummaryPhotos / 2,
        numberOfClusters = 2,
        clusters = new List<Cluster>();
    goal = goal.round();
    clusters.add(cluster.children.elementAt(0));
    clusters.add(cluster.children.elementAt(1));

    while (numberOfClusters != goal) {
      _ManipulationOverClusters.cutAndAddTheBiggest(clusters);
      numberOfClusters = clusters.length;
    }
    listToReturn.addAll(clusters);

    return listToReturn;
  }

  /**
   * 
   * Build the cluster tree
   * 
   */
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
      clusterBuilt = clusteringAlgorithm.performClustering(distances, photoIds, new SingleLinkageStrategy());
      photosIdsToReturn = cutTheTree(clusterBuilt, numberOfSummaryPhotos, numberOfPhotosImported);
      photosToReturn = _ManipulationOverClusters.IdForPhoto(photos, photosIdsToReturn);
    }

    return photosToReturn;
  }
}
