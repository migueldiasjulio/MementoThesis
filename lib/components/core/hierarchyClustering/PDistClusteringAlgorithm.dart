/*******************************************************************************
 * Copyright 2013 Lars Behnke
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
library pdistClusteringAlgorithm;

import 'cluster.dart';
import 'linkageStrategy.dart';
import 'clusterPair.dart';
import 'hierarchyBuilder.dart';
import 'clusteringAlgorithm.dart';
import 'dart:core';

class PDistClusteringAlgorithm extends ClusteringAlgorithm {

    Cluster performClustering(List<List<double>> distances,
      List<String> clusterNames, LinkageStrategy linkageStrategy) {

    /* Argument checks */
    if (distances == null || distances.length == 0) {
      throw new Exception("Invalid distance matrix");
    }
    if (distances.elementAt(0).length != clusterNames.length
        * (clusterNames.length - 1) / 2) {
      throw new Exception("Invalid cluster name array");
    }
    if (linkageStrategy == null) {
      throw new Exception("Undefined linkage strategy");
    }

    /* Setup model */
    List<Cluster> clusters = createClusters(clusterNames);
    List<ClusterPair> linkages = createLinkages(distances, clusters);

    /* Process */
    HierarchyBuilder builder = new HierarchyBuilder(clusters, linkages);
    while(!builder.isTreeComplete()) {
      builder.agglomerate(linkageStrategy);
    }
    return builder.getRootCluster();
  }

  List<ClusterPair> createLinkages(List<List<double>> distances,
      List<Cluster> clusters) {
    List<ClusterPair> linkages = new List<ClusterPair>();
    var clustersLength = clusters.length;
    for (int col = 0; col < clustersLength; col++) {
      Cluster cluster_col = clusters.elementAt(col); // .get(col);
      for (int row = col + 1; row < clusters.length; row++) {
        ClusterPair link = new ClusterPair();
        link.setLinkageDistance(distances.elementAt(0).elementAt(accessFunction(row, col,
            clusters.length)));
        link.setlCluster(cluster_col);
        link.setrCluster(clusters.elementAt(row));
        linkages.add(link);
      }
    }
    return linkages;
  }

  List<Cluster> createClusters(List<String> clusterNames) {
    List<Cluster> clusters = new List<Cluster>();
    for (String clusterName in clusterNames) {
      Cluster cluster = new Cluster(clusterName);
      clusters.add(cluster);
    }
    return clusters;
  }

  // Credit to this function goes to
  // http://stackoverflow.com/questions/13079563/how-does-condensed-distance-matrix-work-pdist
  int accessFunction(int i, int j, int n) {
    return (n * j - j * (j + 1) / 2 + i - 1 - j).toInt();
  }

}