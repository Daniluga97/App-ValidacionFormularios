import 'package:flutter/material.dart';
import 'package:form_validation/src/providers/productos_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/producto_model.dart';
import '../utils/utils.dart' as utils;

import 'dart:io';
class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  
  final formKey               = GlobalKey<FormState>(); 
  final productoProvider      = new ProductosProvider();
  ProductoModel productoModel = new ProductoModel();
  final scaffoldKey           = GlobalKey<ScaffoldState>(); 
  bool _guardando             = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null){
      productoModel = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('Producto'), actions: [
        IconButton(
          icon: Icon(Icons.photo_size_select_actual),
          onPressed: _seleccionarFoto,
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: _hacerFoto,
        ),
      ]),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
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
      onPressed: (_guardando) ? null : _submitControl,
    );
  }

  void _submitControl() async{
    // Cuando el formulario es válido
    if(!formKey.currentState.validate()) return;
    
    // Cuando sí es válido:
    formKey.currentState.save(); // Activa todos los onSaved para guardar datos
    
    setState(() {
      _guardando = true;
    });

    if(foto != null){
      productoModel.fotoUrl = await productoProvider.subirImagen(foto);
    }
    
    /* print(productoModel.titulo);
    print(productoModel.valor);
    print(productoModel.disponible); */

    if (productoModel.id == null) {
      productoProvider.crearProducto(productoModel);
    } else {
      productoProvider.editarProducto(productoModel);
    }

    mostrarSnackBar('Guardado exitosamente');

    Navigator.pop(context); // Después de guardar vuelve a la 'pagina' anterior (home)
  }

  void mostrarSnackBar(String mensaje){
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _mostrarFoto(){
    if (productoModel.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(productoModel.fotoUrl),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    } else {
      if( foto != null ){
        return Image(
          image: AssetImage(foto?.path ?? 'assets/no-image.png'), // Si la foto tiene información, se mostrará la foto, si no, se mostrará el no-image.png
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }
   _seleccionarFoto() async{
    _procesarImagen(ImageSource.gallery);
  }
 
  _hacerFoto() async{
    _procesarImagen(ImageSource.camera);
  }
 
  _procesarImagen(ImageSource origin) async{
    final ImagePicker imagePicker = ImagePicker();
    final PickedFile pickedFile = await imagePicker.getImage(source: origin);
    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
        productoModel.fotoUrl = null;
      } else {
        print('No se seleccionó una foto.');
      }
    });
  }
}
