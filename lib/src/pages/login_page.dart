import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _formularioLogin(context),

        ],
      )
    );
  }

  Widget _crearFondo(context) {
    
    final heightSize = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: heightSize.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      )
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    final logo = Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: [
          Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
          SizedBox(height: 10.0, width: double.infinity,),
          Text("Daniel Luis Garcia", style: TextStyle(color: Colors.white, fontSize: 25.0),)
        ],
      ),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(child: circulo, top: 90.0, left: 30.0),
        Positioned(child: circulo, top: 10.0, right: 10.0),
        Positioned(child: circulo, top: 200.0, right: -10.0),
        Positioned(child: circulo, top: 120.0, right: 100.0),
        Positioned(child: circulo, top: -50.0, left: -20.0),
        logo,
      ],
    );
  }

  Widget _formularioLogin(context) {

    final bloc = Provider.of(context);

    final widthSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200.0,
            )
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            width: widthSize.width*0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: [
                Text("Ingreso", style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 60.0,),
                _crearEmail(bloc),
                SizedBox(height: 30.0,),
                _crearPassword(bloc),
                SizedBox(height: 30.0,),
                _crearBoton(bloc)
              ]
            ),
          ),
          Text("¿Olvidaste tu contraseña?"),
          SizedBox(height: 100.0,)
        ],
      )
    );

  }

  Widget _crearEmail(LoginBloc bloc) {
    
    return StreamBuilder(
      stream: bloc.emailStream ,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: "ejemplo@email.com",
              labelText: "Correo electrónico",
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          )
        );
      }
    );
      
  }

    Widget _crearPassword(LoginBloc bloc) {
    
    return StreamBuilder(
      stream: bloc.passwordStream,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: "Contraseña",
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          )
        );
      },
    );
  }
  
  Widget _crearBoton(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text("Ingresar"),
          ),
          onPressed: snapshot.hasData ? (){return _login(context, bloc);} : null
        );
      },
   );
  }    

  _login(BuildContext context, LoginBloc bloc){
    print("==============");
    print("Email: ${bloc.email}");
    print("Password: ${bloc.password}");
    print("==============");
    
    Navigator.pushReplacementNamed(context, "home");
  }




}