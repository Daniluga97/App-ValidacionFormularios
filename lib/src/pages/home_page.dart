import 'package:flutter/material.dart';
import 'package:form_validation/src/Models/producto_model.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  
  final productosProvider = new ProductosProvider();

  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(){
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(snapshot.hasData){
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i])
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel productoModel){
    return Dismissible(
      key: UniqueKey(), // Necesita esto a fuerza
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        productosProvider.borrarProducto(productoModel.id);
      },
     child: Card(
       child: Column(
         children: [
           (productoModel.fotoUrl == null) 
           ? Image(image: AssetImage('assets/no-image.png'))
           : FadeInImage(
             image: NetworkImage(productoModel.fotoUrl), // Coge la foto de la BBDD Cloudinary
             placeholder: AssetImage('assets/jar-loading.gif'),
             height: 300.0,
             width: double.infinity,
             fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${productoModel.titulo} - ${productoModel.valor}'),
              subtitle: Text(productoModel.id),
              onTap: () => Navigator.pushNamed(context, 'product', arguments: productoModel).then((value) => setState((){})),
            ),
         ],
       ),
     )
    );
/* 
     */
  }

  _crearBoton(context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product').then((value) => setState((){})),
    );
  }
}
