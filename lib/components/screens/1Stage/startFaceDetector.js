var FaceDetector = function(){


this.comp = function(image){

  //image = new Image();
  //image.src = source;

  ccv.detect_objects({ "canvas" : ccv.grayscale(ccv.pre(image)),
                      "cascade" : cascade,
                      "interval" : 5,
                      "min_neighbors" : 1 });
                      
}

};