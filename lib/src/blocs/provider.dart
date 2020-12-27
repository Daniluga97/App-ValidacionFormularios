import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/login_bloc.dart';
export 'package:form_validation/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget{

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    // Saber si se necesita crear una nueva instancia o no
    if (_instancia == null) {
      _instancia = Provider._(key: key, child: child);
    }

    return _instancia;
  }
  
  Provider._({Key key, Widget child}) : super(key: key, child: child);

  final loginBloc = LoginBloc();

  // Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  
  static LoginBloc of ( BuildContext context ){
    // En el contexto (árbol de widgets) se va a buscar aquél widget
    // que tenga el mismo tipo que el "Provider"
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  } 

}