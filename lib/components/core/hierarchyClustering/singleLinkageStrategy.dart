library singleLinkageStrategy;

import 'linkageStrategy.dart';

class SingleLinkageStrategy extends LinkageStrategy {

  double calculateDistance(List<double> distances) {
    double min = double.NAN;

    for (double dist in distances) {
        if (min.isNaN || dist < min)
            min = dist;
    }
    return min;
  }
}