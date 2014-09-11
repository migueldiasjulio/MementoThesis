library phototype;

import 'image.dart';
import 'GroupOfPhotos/similarGroupOfPhotos.dart';
import 'GroupOfPhotos/groupOfPhotos.dart';
import 'GroupOfPhotos/colorGroupOfPhotos.dart';
import 'GroupOfPhotos/facesGroupOfPhotos.dart';
import 'GroupOfPhotos/dayMomentGroupOfPhotos.dart';
import 'GroupOfPhotos/qualityGroupOfPhotos.dart';
import '../categories/category.dart';
import '../exif/exifData.dart';

class Photo extends Image implements Comparable<Photo> {

  /*
   * 
   */ 
  static int _COUNT = 1;
  String id, title, _mainSrc;
  double _dataInformation = 0.0;
  Image _thumbnail, _thumbnailToShow, _miniThumbnailToShow;
  bool _isColor = false,
       _hasFaces = false,
       _isDay = false;
  ExifData _exifData = null;
  List<Category> _categories;
  List<double> _descriptor = null;
  List<Photo> _similarPhotos = null,
              almostTheSamePhoto = null;
  SimilarGroupOfPhotos _similarGroup = null;
  ColorGroupOfPhotos _colorGroup = null;
  FacesGroupOfPhotos _facesGroup = null;
  DayMomentGroupOfPhotos _dayMomentGroup = null;
  QualityGroupOfPhotos _qualityGroup = null;
  double _histogramValuesDifference = 0.0;

  Photo(String src, String title)
      : id = "photo_${_COUNT++}",
        title = title,
        _mainSrc = src,
        _similarPhotos = new List<Photo>(),
        _categories = new List<Category>(),
        almostTheSamePhoto = new List<Photo>(),
        super(src);

  /*
   * Get functions
   */
      
  /*
   * 
   */   
  Image get thumbnail {
    if (_thumbnail == null) {
      _thumbnail = createThumbnail(256, 256);
    }
    
    return _thumbnail;
  }

  /*
   * 
   */ 
  Image get thumbnailToShow {
    if (_thumbnailToShow == null) {
      _thumbnailToShow = createThumbnailToShow(false);
    }
    
    return _thumbnailToShow;
  }

  /*
   * 
   */ 
  Image get miniThumbnailToShow {
    if (_miniThumbnailToShow == null) {
      _miniThumbnailToShow = createThumbnailToShow(true);
    }
    
    return _miniThumbnailToShow;
  }

  /*
   * 
   */ 
  List<Photo> get similarPhotos => _similarPhotos;
  List<Category> get returnCategory => _categories;
  double get dataFromPhoto => _dataInformation;
  String get mainSrc => _mainSrc;
  List<double> get photoDescriptor => _descriptor;
  bool get isColor => _isColor;
  bool get hasFaces => _hasFaces;
  bool get isDay => _isDay;
  SimilarGroupOfPhotos get returnSimilarGroup => _similarGroup;
  ColorGroupOfPhotos get returnColorGroup => _colorGroup;
  FacesGroupOfPhotos get returnFacesGroup => _facesGroup;
  DayMomentGroupOfPhotos get returnDayMomentGroup => _dayMomentGroup;
  QualityGroupOfPhotos get returnQualityGroup => _qualityGroup;
  double get histogramDiff => _histogramValuesDifference;
  ExifData get returnExifData => _exifData;
  bool get hasSimilarPhotos{
    if(_similarPhotos.length > 0){
      return true;
    }
    return false;
  }
  bool get lowQuality{
    if(_histogramValuesDifference > 0.70){
      return true;
    }
    return false;
  }
  bool get mediumQuality{
    if(_histogramValuesDifference > 0.25 && _histogramValuesDifference <= 0.70){
      return true;
    }
    return false;
  }
  bool get goodQuality{
    if(_histogramValuesDifference <= 0.25){
      return true;
    }
    return false;
  }

  /*
   * CompareTo function. To compare this photo with other placed as argument
   */
  int compareTo(Photo o) {
    var result;
    if (o == null || o.dataFromPhoto == null) {
      result = -1;
    } else if (o.dataFromPhoto == null) {
      result = 1;
    } else {
      result = dataFromPhoto.compareTo(o.dataFromPhoto);
    }

    return result;
  }

  /*
   * Operator ==
   */
  operator ==(other) => other.id == id;


  /*
   * 
   */
  bool containsCategory(Category category) => _categories.contains(category);
  
  /*
   * 
   */
  void addNewCategory(Category _category) => _categories.add(_category);
  
  /*
   * 
   */
  void addSimilarPhotos(List<Photo> photos) => similarPhotos.addAll(photos);

  /*
   * 
   */
  bool thisOneIsColor() => _isColor = true;
  
  /*
   * 
   */
  bool thisOneHasFaces() => _hasFaces = true;

  /*
   * 
   * Groups
   * 
   */
  
  /*
   * 
   */
  void removeGroup(GroupOfPhotos group) {
    switch (group.groupName) {
      case "With Faces":
        removeFacesGroup();
        break;
      case "Without Faces":
        removeFacesGroup();
        break;
      case "Night":
        removeDayMomentGroup();
        break;
      case "Day":
        removeDayMomentGroup();
        break;
      case "Color":
        removeColorGroup();
        break;
      case "Black and White":
        removeColorGroup();
        break;
      case "Good Quality":
        removeQualityGroup();
        break;
      case "Medium Quality":
        removeQualityGroup();
        break;
      case "Poor Quality":
        removeQualityGroup();
        break;
      case "Similar":
        removeSimilarGroup();
        break;
      default:
        break;
    }
  }

  /*
   * 
   */
  void addGroup(GroupOfPhotos group) {
    switch (group.groupName) {
      case "With Faces":
        setFacesGroup(group);
        break;
      case "Without Faces":
        setFacesGroup(group);
        break;
      case "Night":
        setDayMomentGroup(group);
        break;
      case "Day":
        setDayMomentGroup(group);
        break;
      case "Color":
        setColorGroup(group);
        break;
      case "Black and White":
        setColorGroup(group);
        break;
      case "Good Quality":
        setQualityGroup(group);
        break;
      case "Medium Quality":
        setQualityGroup(group);
        break;
      case "Poor Quality":
        setQualityGroup(group);
        break;
      case "Similar":
        setSimilarGroup(group);
        break;
      default:
        break;
    }
  }
 
  /*
   * 
   */
  GroupOfPhotos returnTheCorrectGroup(bool sameCategory, bool toningCategory,
                                      bool facesCategory, bool dayMomentCategory, bool qualityCategory) {
    var groupToReturn = null;
    if (sameCategory) {
      groupToReturn = returnSimilarGroup;
    }
    if (toningCategory) {
      groupToReturn = returnColorGroup;
    }
    if (facesCategory) {
      groupToReturn = returnFacesGroup;
    }
    if (dayMomentCategory) {
      groupToReturn = returnDayMomentGroup;
    }
    if (qualityCategory) {
      groupToReturn = returnQualityGroup;
    }
    return groupToReturn;
  }

  /*
   * Set functions
   */
  
  /*
   * 
   */
  double setHistogramDiff(double newValue) => _histogramValuesDifference = newValue;
  
  /*
   * 
   */
  List<Category> setCategories(List<Category> categories) => _categories = categories;

  /*
   * 
   */
  void setExifData(ExifData exifInfo) {
    _exifData = exifInfo;
  }
  
  bool setMomentOfDay(bool isDay) => _isDay = isDay;

  /*
   * 
   */
  void setDescriptor(List<double> newDescriptor) {
    _descriptor = newDescriptor;
  }

  /*
   * 
   */
  void setDataFromPhoto() {
    _dataInformation = _exifData.dateDoubleValue;
  }
  
  void setSecondsDataInformation(double info){
    _dataInformation = info;
  }
  
  /*
   * 
   */
  void setSimilarGroup(SimilarGroupOfPhotos similarGroup) {
    _similarGroup = similarGroup;
  }

  /*
   * 
   */
  void setColorGroup(ColorGroupOfPhotos colorGroup) {
    _colorGroup = colorGroup;
  }

  /*
   * 
   */
  void setFacesGroup(FacesGroupOfPhotos facesGroup) {
    _facesGroup = facesGroup;
  }

  /*
   * 
   */
  void setDayMomentGroup(DayMomentGroupOfPhotos dayMomentGroup) {
    _dayMomentGroup = dayMomentGroup;
  }
  
  /*
   * 
   */
  void setQualityGroup(QualityGroupOfPhotos qualityGroup) {
    _qualityGroup = qualityGroup;
  }

/*
 * Remove Functions
 */
  
  /*
   * Remove Function - Similar Group
   */
  void removeSimilarGroup() {
    _similarGroup = null;
  }

  /*
   * Remove Function - Color Group
   */
  void removeColorGroup() {
    _colorGroup = null;
  }

  /*
   * Remove Function - Faces Group
   */
  void removeFacesGroup() {
    _facesGroup = null;
  }

  /*
   * Remove Function - Day Moment Group
   */
  void removeDayMomentGroup() {
    _dayMomentGroup = null;
  }
  
  /*
   * Remove Function - Quality Group
   */
  void removeQualityGroup() {
    _qualityGroup = null;
  }

}