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
library defaultClusteringAlgorithm;

import 'cluster.dart';
import 'clusterPair.dart';
import 'hierarchyBuilder.dart';
import 'clusteringAlgorithm.dart';
import 'linkageStrategy.dart';
import 'dart:core';

class DefaultClusteringAlgorithm extends ClusteringAlgorithm {

  Cluster performClustering(List<List<double>> distances,
          List<String> clusterNames, LinkageStrategy linkageStrategy) {

    /* Argument checks */
    if (distances == null || distances.length == 0
            || distances[0].length != distances.length) {
      throw new Exception("Invalid distance matrix");
    }
    if (distances.length != clusterNames.length) {
      throw new Exception("Invalid cluster name array");
    }
    if (linkageStrategy == null) {
      throw new Exception("Undefined linkage strategy");
    }

    /* Setup model */
    List<Cluster> clusters = createClusters(clusterNames);
    List<ClusterPair> linkages = createLinkages(distances, clusters);
    
    print("SETUP DONE!");

    /* Process */
    HierarchyBuilder builder = new HierarchyBuilder(clusters, linkages);
    while(!builder.isTreeComplete()) {
      builder.agglomerate(linkageStrategy);
    }
    
    print("PROCESS DONE!");

    return builder.getRootCluster();
  }

  List<ClusterPair> createLinkages(List<List<double>> distances,
          List<Cluster> clusters) {
    print("Creating Linkages!");
    List<ClusterPair> linkages = new List<ClusterPair>();
    for (int col = 0; col < clusters.length; col++) {
      for (int row = col + 1; row < clusters.length; row++) {
        ClusterPair link = new ClusterPair();
        link.setLinkageDistance(distances.elementAt(col).elementAt(row));
        link.setlCluster(clusters.elementAt(col));
        link.setrCluster(clusters.elementAt(row));
        linkages.add(link);
      }
    }
    print("Linkages created: " + linkages.toString());
    return linkages;
  }

  List<Cluster> createClusters(List<String> clusterNames) {
    print("Creating Clusters!");
    List<Cluster> clusters = new List<Cluster>();
        for (String clusterName in clusterNames) {
            Cluster cluster = new Cluster(clusterName);
            clusters.add(cluster);
        }
        
    print("Clusters created: " + clusters.toString());
    return clusters;
  }

}