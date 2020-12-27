// import 'package:flutter/material.dart';

import 'dart:async';

import 'package:form_validation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with ValidatorsBloc{

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  

  //Recuperar los datos del stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
 
  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);


  // Insertar valores al stream
   //get chancheEmail apunta a _emailController.sink.add
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;


  dispose(){
    //Si es null, no lo cierres (por eso tiene el ?)
    _emailController?.close();
    _passwordController?.close();
  }
}