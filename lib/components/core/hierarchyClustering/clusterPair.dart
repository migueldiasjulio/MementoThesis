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
library clusterPair;

import 'cluster.dart';

class ClusterPair implements Comparable<ClusterPair> {

  Cluster lCluster;
  Cluster rCluster;
  double linkageDistance;

  Cluster getlCluster() {
    return lCluster;
  }

  void setlCluster(Cluster lCluster) {
    this.lCluster = lCluster;
  }

  Cluster getrCluster() {
    return rCluster;
  }

  void setrCluster(Cluster rCluster) {
    this.rCluster = rCluster;
  }

  double getLinkageDistance() {
    return linkageDistance;
  }

  void setLinkageDistance(double distance) {
    this.linkageDistance = distance;
  }

  int compareTo(ClusterPair o) {
    int result;
    if (o == null || o.getLinkageDistance() == null) {
      result = -1;
    } else if (getLinkageDistance() == null) {
      result = 1;
    } else {
      result = getLinkageDistance().compareTo(o.getLinkageDistance());
    }

    return result;
  }

   Cluster agglomerate(String name) {
    if (name == null) {
      StringBuffer sb = new StringBuffer();
      if (lCluster != null) {
        sb.write(lCluster.getName());
      }
      if (rCluster != null) {
        if (sb.length > 0) {
          sb.write("&");
        }
        sb.write(rCluster.getName());
      }
      name = sb.toString();
    }
    Cluster cluster = new Cluster(name);
    cluster.setDistance(getLinkageDistance());
    cluster.addChild(lCluster);
    cluster.addChild(rCluster);
    lCluster.setParent(cluster);
    rCluster.setParent(cluster);
    return cluster;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    if (lCluster != null) {
      sb.write(lCluster.getName());
    }
    if (rCluster != null) {
      if (sb.length > 0) {
        sb.write(" + ");
      }
      sb.write(rCluster.getName());
    }
    sb.writeAll([" : ", linkageDistance]);
    return sb.toString();
  }

}