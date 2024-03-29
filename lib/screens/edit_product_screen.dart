import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus) {

      if (
        // _imageUrlController.text.isEmpty || 
        ( !_imageUrlController.text.startsWith('https') && 
        !_imageUrlController.text.startsWith('https') ) || 
        !_imageUrlController.text.endsWith('.png') && 
        !_imageUrlController.text.endsWith('.jpg') && 
        !_imageUrlController.text.endsWith('.jpeg')
      ) {
        return;
      }
      setState(() {});

    }

  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false).updateProduct(
        _editedProduct.id, _editedProduct
      );

    } else {

      try{
        await Provider.of<ProductsProvider>(context, listen: false).addProduct(
          _editedProduct
        );
      } catch (error) {

        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occur'),
            content : Text('something went wrong !'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'), 
                onPressed: () {
                  Navigator.of(ctx).pop();  
                }
              )
            ],
          )
        );

      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });

      //   Navigator.of(context).pop();
      // }

    }

     setState(() {
        _isLoading = false;
    });
    Navigator.of(context).pop();

    // Navigator.of(context).pop();

    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),

      body: (_isLoading) 
      ? Center(child: CircularProgressIndicator()) 
      : Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[

              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },

                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: null
                  );
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  }

                  return null;
                },

              ),

              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },

                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: null
                  );
                },

                validator: (value) {
                  if (double.tryParse(value) == null) {
                    return 'Please enter a price  ';
                  }

                  if (double.parse(value) <= 0) {
                    return 'invalid price';
                  }

                  return null;
                },


              ),

              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,

                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: null
                  );
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }

                  if (value.length < 10) {
                    return 'minimum 10 caractere';
                  }

                  return null;
                },

              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget> [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey
                      )
                    ),

                    child: _imageUrlController.text.isEmpty 
                      ? Text('Enter a url')
                      :FittedBox(
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                      )
                  ),

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },

                    onSaved: (value) {
                        _editedProduct = Product(
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        imageUrl: value,
                        id: null
                      );
                    },

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a URL';
                      }

                      if (!value.startsWith('https') && !value.startsWith('http')) {
                        return 'Please enter a valid URL';
                      }

                      if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image URL';
                      }

                      return null;
                  },

                    ),
                  )
                ]
              )
            ],
          ),
        ),
      )
    );
  }
}