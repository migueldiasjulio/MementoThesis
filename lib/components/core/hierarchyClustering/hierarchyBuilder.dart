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
library hierarchyBuilder;

import 'dart:core';
import 'cluster.dart';
import 'clusterPair.dart';
import 'linkageStrategy.dart';

class HierarchyBuilder {

  List<ClusterPair> distances;
  List<Cluster> clusters;

  List<ClusterPair> getDistances() {
    return distances;
  }

  List<Cluster> getClusters() {
    return clusters;
  }

  HierarchyBuilder(List<Cluster> clusters, List<ClusterPair> distances) {
    this.clusters = clusters;
    this.distances = distances;
  }

  void agglomerate(LinkageStrategy linkageStrategy) {
    distances.sort();
    //Collections.sort(distances);
    if (distances.length > 0) {
      ClusterPair minDistLink = distances.removeAt(0);
      clusters.remove(minDistLink.getrCluster());
      clusters.remove(minDistLink.getlCluster());

      Cluster oldClusterL = minDistLink.getlCluster();
      Cluster oldClusterR = minDistLink.getrCluster();
      Cluster newCluster = minDistLink.agglomerate(null);

      for (Cluster iClust in clusters) {
        ClusterPair link1 = findByClusters(iClust, oldClusterL);
        ClusterPair link2 = findByClusters(iClust, oldClusterR);
        ClusterPair newLinkage = new ClusterPair();
        newLinkage.setlCluster(iClust);
        newLinkage.setrCluster(newCluster);
        List<double> distanceValues = new List<double>();
        if (link1 != null) {
          distanceValues.add(link1.getLinkageDistance());
          distances.remove(link1);
        }
        if (link2 != null) {
          distanceValues.add(link2.getLinkageDistance());
          distances.remove(link2);
        }
        double newDistance = linkageStrategy
                .calculateDistance(distanceValues);
        newLinkage.setLinkageDistance(newDistance);
        distances.add(newLinkage);

      }
      clusters.add(newCluster);
    }
  }

  ClusterPair findByClusters(Cluster c1, Cluster c2) {
    ClusterPair result = null;
    for (ClusterPair link in distances) {
      bool cond1 = link.getlCluster().equals(c1)
              && link.getrCluster().equals(c2);
      bool cond2 = link.getlCluster().equals(c2)
              && link.getrCluster().equals(c1);
      if (cond1 || cond2) {
        result = link;
        break;
      }
    }
    return result;
  }

  bool isTreeComplete() {
    return clusters.length == 1;
  }

  Cluster getRootCluster() {
    if (!isTreeComplete()) {
      throw new Exception("No root available"); 
    }
    return clusters.elementAt(0); 
  }

}