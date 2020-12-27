import 'dart:async';

// import 'package:flutter/material.dart';



class ValidatorsBloc {

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 6){
        sink.add(password);
      } else {
        sink.addError("Más de 6 caracteres por favor creck.");
      }
    }
  );

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      Pattern patronEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp expresionRegular = RegExp(patronEmail);
      if(expresionRegular.hasMatch(email)){
        sink.add(email);
      } else {
        sink.addError("No está bien, ASESINO");
      }
    }
  );

}


// Stream<bool> get formValidStream =>
//        Rx.combineLatest2(emailStream, passwStream, (e, p) => true);


//        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';