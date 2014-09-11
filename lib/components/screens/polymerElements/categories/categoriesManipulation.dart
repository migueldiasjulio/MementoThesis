library categoriesmanipulation;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
export 'package:route_hierarchical/client.dart';
/*
 * 
 */ 
typedef void facesCategoryExecution();
typedef void dayMomentCategoryExecution();
typedef void toningCategoryExecution();
typedef void similarCategoryExecution();

@CustomTag('categories-manipulation-element')
class CategoriesManipulation extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  @published facesCategoryExecution facesCategoryExecutionFunction;
  @published dayMomentCategoryExecution dayMomentCategoryExecutionFunction;
  @published toningCategoryExecution toningCategoryExecutionFunction;
  @published similarCategoryExecution similarCategoryExecutionFunction;
  @published similarCategoryExecution qualityCategoryExecutionFunction;
  @published bool sameCategory;
  @published bool facesCategory;
  @published bool dayMomentCategory; 
  @published bool toningCategory;
  @published bool qualityCategory;
  
  /*
   * 
   */ 
  CategoriesManipulation.created() : super.created(){
   
  }
  
  void facesCategoryExecutionPlease() => facesCategoryExecutionFunction();
  void dayMomentCategoryExecutionPlease() => dayMomentCategoryExecutionFunction();
  void toningCategoryExecutionPlease() => toningCategoryExecutionFunction();
  void qualityCategoryExecutionPlease() => qualityCategoryExecutionFunction();
  void similarCategoryExecutionPlease() => similarCategoryExecutionFunction();
  
}