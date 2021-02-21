import 'package:flutter/material.dart';

import '../Models/producto_model.dart';
import '../utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>(); 

  ProductoModel productoModel = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Producto'), actions: [
        IconButton(
          icon: Icon(Icons.photo_size_select_actual),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {},
        ),
      ]),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )
            )
        )
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: productoModel.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null; // Pasa sin ningun problema
        }
      },
      onSaved: (value) => productoModel.titulo = value,
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: productoModel.valor.toString(), //initialValue necesita Strings
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      validator: (value) {
        if (utils.esNumero(value)) {
          return null; // Se puede trabajar
        } else {
          return 'Solo números';
        }
      } ,
      onSaved: (value) => productoModel.valor = double.parse(value),
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: productoModel.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
          productoModel.disponible = value;
      })
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: _submitControl,
    );
  }

  void _submitControl(){
    // Cuando el formulario es válido
    if(!formKey.currentState.validate()) return;
    
    // Cuando sí es válido:
    formKey.currentState.save(); // Activa todos los onSaved para guardar datos
    print('Todo OK');

    print(productoModel.titulo);
    print(productoModel.valor);
    print(productoModel.disponible);
  }
}
