import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/config/size_config.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();

  final _imageUrlFocusNode = FocusNode();

  final _imageUrlTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _editedProduct = ProductProvider(
      id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initialValue = {
    'id': null,
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlTextEditing.text.startsWith('http') &&
              !_imageUrlTextEditing.text.startsWith('https')) ||
          (!_imageUrlTextEditing.text.endsWith('.jpg') &&
              !_imageUrlTextEditing.text.endsWith('.png') &&
              !_imageUrlTextEditing.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct, _editedProduct.id);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An Error Occurred!"),
                  content: Text("Something went wrong."),
                  actions: [
                    FlatButton(
                      child: Text("Okay!"),
                      onPressed: () => Navigator.of(ctx).pop(),
                    )
                  ],
                ));
      }

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlTextEditing.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initialValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlTextEditing.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_imageUrlTextEditing.text.isEmpty?"Add Product":"Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initialValue['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: _priceFocusNode,
                        initialValue: _initialValue['price'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'Please enter a number grater Than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _initialValue['description'],
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length <= 10) {
                            return 'Should e at least 10 characters long.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = ProductProvider(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: getProportionateScreenWidth(100),
                          height: getProportionateScreenHeight(100),
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlTextEditing.text.isEmpty
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child: Image.network(
                                      _imageUrlTextEditing.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(child:TextFormField(
                          controller: _imageUrlTextEditing,
                          focusNode: _imageUrlFocusNode,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Image URL',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a Image URL';
                            }
                            if (!value.startsWith('http')&&!value.startsWith('https') ) {
                              return 'Please enter a valid Image URL';
                            }
                            if (!value.endsWith('jpg')&&!value.endsWith('jpeg')&&!value.endsWith('png') ) {
                              return 'Please enter a valid Image URL';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageUrl: value,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),)
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
