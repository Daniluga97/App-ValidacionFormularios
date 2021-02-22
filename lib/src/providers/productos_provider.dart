// Encargado de hacer las interacciones directas con la BBDD
import 'package:form_validation/src/Models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

import 'dart:convert';
import 'dart:io';

class ProductosProvider{
  
  // Entras en Realtime Database y aparecerá este enlace.
  final String _url = 'https://flutter-varios-78b24-default-rtdb.europe-west1.firebasedatabase.app';

  Future<bool> crearProducto(ProductoModel productoModel) async {
    
    final url = '$_url/productos.json';
   
    final respuesta = await http.post(url, body: productoModelToJson(productoModel));
    
    final decodedData = json.decode(respuesta.body);

    print(decodedData); // Muestra todo lo que hay dentro de 'productos' en Firebase

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    
    final url = '$_url/productos.json';
    
    final respuesta = await http.get(url); // Petición HTTP GET
    
    final Map<String, dynamic> decodedData = json.decode(respuesta.body);
    
    final List<ProductoModel> productos = new List();

    if (decodedData == null) {
      return [];
    }

    decodedData.forEach((id, producto) {
      // print(producto);
      final productoTemporal = ProductoModel.fromJson(producto);
      productoTemporal.id = id;
      productos.add(productoTemporal);
     });
    // print(productos[0].id);
    // print(decodedData); // Muestra esto: I/flutter (18669): {-MU8Bx92Ld6DEFGPDE-e: {disponible: true, titulo: Celular, valor: 1000.55}, ABC123: {disponible: true, precio: 100, titulo: Tamales}, XYZ123: {titulo: Carros}}
    return productos;
  }

  Future<int> borrarProducto(String id) async{
    final url = '$_url/productos/$id.json';
    
    final respuesta = await http.delete(url);

    print(respuesta.body);
    
    return 1;
  }
  
  Future<bool> editarProducto(ProductoModel productoModel) async {
    
    final url = '$_url/productos/${productoModel.id}.json';
   
    final respuesta = await http.put(url, body: productoModelToJson(productoModel));
    
    final decodedData = json.decode(respuesta.body);

    print(decodedData);

    return true;
  }

  Future<String> subirImagen(File imagen) async {
    
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dxy55u9sv/image/upload?upload_preset=tsk3pk11');
    
    final mimeType = mime(imagen.path).split('/'); // image/jpg

    final imageUploadRequest = http.MultipartRequest('POST', url);
  
    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]) // 0: imagen, 1: jpeg
    ); // 'file' es el campo de Postman

    imageUploadRequest.files.add(file); // Petición de subida

    final streamResponse = await imageUploadRequest.send();
    
    final respuesta = await http.Response.fromStream(streamResponse);

    if(respuesta.statusCode != 200 && respuesta.statusCode != 201){
      print('Algo salió mal');
      print(respuesta.body);
      return null;
    }

    final responseData = json.decode(respuesta.body);
    
    print(responseData);
   
    return responseData['secure_url'];
  }
}