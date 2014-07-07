library functionchoosed;

class FunctionChoosed{
  
  final _value;
  const FunctionChoosed._internal(this._value);
  toString() => 'FunctionCoosed.$_value';

  static const FIRSTX = const FunctionChoosed._internal('FIRSTX');
  static const RANDOM = const FunctionChoosed._internal('RANDOM');
  static const HIERARCHICAL = const FunctionChoosed._internal('HIERARCHICAL');

}