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
library cluster;

import 'dart:core';

class Cluster {

  String name;
  Cluster parent;
  List<Cluster> children;
  double distance;

  double getDistance() {
    return distance;
  }

  void setDistance(double distance) {
    this.distance = distance;
  }

  List<Cluster> getChildren() {
    if (children == null) {
      children = new List<Cluster>();
    }
    return children;
  }

  void setChildren(List<Cluster> children) {
    this.children = children;
  }

  Cluster getParent() {
    return parent;
  }

  void setParent(Cluster parent) {
    this.parent = parent;
  }

  
  Cluster(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  void addChild(Cluster cluster) {
    getChildren().add(cluster);

  }

  bool contains(Cluster cluster) {
    return getChildren().contains(cluster);
  }


  String toString() {
    return "Cluster " + name;
  }

  bool equals(Object obj) {
    String otherName = obj != null ? obj.toString() : "";
    return toString() == otherName;
  }
                                                          
  int hashCodeSecond() {
    return toString().hashCode;
  }

  bool isLeaf() {
    return getChildren().length == 0;
  }
  
  int countLeafs(Cluster node, int count) {
        if (node.isLeaf()){
          count++;
        }
        for (Cluster child in node.getChildren()) {
            count += child.countLeafsSecond();
        }
        return count;
  }
  
  int countLeafsSecond() {
      return countLeafs(this, 0);
  }
    
    void toConsole(int indent) {
        for (int i = 0; i < indent; i++) {
            print("  ");        
        }
        String name = getName() + (isLeaf() ? " (leaf)" : "") + (distance != null ? "  distance: " 
            + distance.toString() : "");
        print(name);
        for (Cluster child in getChildren()) {
            child.toConsole(indent + 1);
        }
    }

    double getTotalDistance() {
      double dist = getDistance() == null ? 0 : getDistance();
        if (getChildren().length > 0) {
            dist += children.elementAt(0).getTotalDistance();
        }
        return dist;

    }
     
}