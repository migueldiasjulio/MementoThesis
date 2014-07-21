library mementosettings;

import 'FunctionChoosed.dart' as Function;

class MementoSettings {

  static MementoSettings _instance;
  var _function = Function.FunctionChoosed.FIRSTX;

  /**
   * Singleton
   */
  MementoSettings._();

  /**
   * Return a reference for the MementoSettings Singleton instance
   */ 
  static MementoSettings get() {
    if (_instance == null) {
      _instance = new MementoSettings._(); 
    }
    return _instance;
  }
  
  /**
   * Return the function to use to build the summary
   * @return Function.FunctionChoosed
   */ 
  Function.FunctionChoosed whichAlgorithmInUse(){
    return this._function;
  }
  
  /**
   * Set function that user want to use
   * @param functionName
   */ 
  void setFunction(String functionName){
    switch(functionName){
      case("FIRSTX") :
        _function = Function.FunctionChoosed.FIRSTX;
      
        print("");
        print("Setting function firstx");
        break;
      case("RANDOM") :
        _function = Function.FunctionChoosed.RANDOM;
      
        print("");
        print("Setting function random");
        break;
      case("HIERARCHICAL") :
        _function = Function.FunctionChoosed.HIERARCHICAL;
      
        print("");
        print("Setting function hierarchical");
        break;
      default: break;
    }
  }
  
}