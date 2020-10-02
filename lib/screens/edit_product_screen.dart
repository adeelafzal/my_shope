import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/models/products.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct = Products(
    desc: '',
    price: '0',
    id: null,
    imageUrl: '',
    title: '',
  );

  var inItValue = {
    'title': '',
    'desc': '',
    'price': '',
    'imageUrl': '',
  };

  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    print('initState');
    _imageFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);
        inItValue = {
          'title': _editProduct.title,
          'desc': _editProduct.desc,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: isLoading
          ? SpinKitFadingCircle(
              color: Theme.of(context).accentColor,
              size: 50.0,
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: inItValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a product title.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Products(
                          desc: _editProduct.desc,
                          price: _editProduct.price,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          imageUrl: _editProduct.imageUrl,
                          title: value,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: inItValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a product price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price.';
                        }
                        if (double.tryParse(value) <= 0) {
                          return 'Product price must be greater than zero..';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Products(
                          desc: _editProduct.desc,
                          price: value,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          imageUrl: _editProduct.imageUrl,
                          title: _editProduct.title,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: inItValue['desc'],
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a product description.';
                        }
                        if (value.length < 10) {
                          return 'Description should be atleast 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Products(
                          desc: value,
                          price: _editProduct.price,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          imageUrl: _editProduct.imageUrl,
                          title: _editProduct.title,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                            )),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                    'Enter a image URl',
                                    textAlign: TextAlign.center,
                                  ))
                                : Image.network(
                                    _imageUrlController.text,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  )),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a image url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid url.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image url.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Products(
                                desc: _editProduct.desc,
                                price: _editProduct.price,
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite,
                                imageUrl: value,
                                title: _editProduct.title,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editProduct.id != null) {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProducts(_editProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }
}
