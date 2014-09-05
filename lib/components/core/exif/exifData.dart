library exifdata;

import 'exifManager.dart';

final _exifManager = ExifManager.get();
class ExifData {
  
  DateTime _creationDate = null;
  DateTime _lastModified = null;
  String _photoID;
  double _dateIntoDouble = 0.0;
  int year,
      month,
      day,
      hour,
      minutes,
      seconds,
      milliseconds;
  
  
  ExifData(String photoID, DateTime lastModified, String creationDate){
    _photoID = photoID;
    setLastModifiedInformation(lastModified);
    setCreationDateInformation(creationDate);
    workOnDoubleDataValue();
  }
  
  void workOnDoubleDataValue(){
    if(_creationDate != null){
      _dateIntoDouble = dateTimeToDouble(_creationDate);
    }else{
      _dateIntoDouble = dateTimeToDouble(_lastModified);
    }
  }
  
  void saveInformation(int year, int month, int day, int hour,
                       int minutes, int seconds, int milliseconds){
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = hour;
    this.minutes = minutes;
    this.seconds = seconds;
    this.milliseconds = milliseconds;
  }
  
  double dateTimeToDouble(DateTime date){
    ReturnObject object = _exifManager.firstNormalization(date);
    saveInformation(object.year, object.month, object.day, object.hour, 
                        object.minutes, object.seconds, object.milliseconds);
    
    return object.valueToSave;
  }
  
  double get dateDoubleValue => _dateIntoDouble;
  DateTime get creationDate => _creationDate;
  DateTime get lastModified => _lastModified;
  String get lastModifiedString => _lastModified.toString();
  String get creationDateString{
    if(_creationDate.toString() == "" || _creationDate == null){return "Not specified";}
    else{
     return _creationDate.toString(); 
    }
  }
  
  /*
   * 
   */
  void setLastModifiedInformation(DateTime dateTime) {
    _lastModified = dateTime;
  }
  
  /*
   * 
   */
  void setCreationDateInformation(String creation) {
    if(creation != null && creation != ""){
      var aux = creation.replaceFirst(":","-"),
          secondAux = aux.replaceFirst(":","-");
      
      DateTime dateTime = DateTime.parse(secondAux);
      _creationDate = dateTime;
    }
  }
  
  
}