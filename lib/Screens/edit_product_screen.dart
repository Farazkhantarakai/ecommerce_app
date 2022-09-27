import 'dart:developer';
import '../Provider/Products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../Provider/Product.dart';

class EditedProductScreen extends StatefulWidget {
  const EditedProductScreen({Key? key}) : super(key: key);

  static const routName = 'EditedProductScreen';

  @override
  State<EditedProductScreen> createState() => _EditedProductScreenState();
}

class _EditedProductScreenState extends State<EditedProductScreen> {
  final _priceNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlEditingController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', prices: 0.0, imageUrl: '');
  bool isInit = true;
  var initialValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  void updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    //this will dispose it other memory leak will occur
    _imageUrlFocusNode.removeListener(updateImage);
    _priceNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      var prodId = ModalRoute.of(context)!.settings.arguments;
      if (prodId != null) {
        _editedProduct = Provider.of<Products>(context)
            .item
            .singleWhere((element) => element.id == prodId);
        initialValue = {
          'title': _editedProduct.title,
          'price': _editedProduct.prices.toString(),
          'description': _editedProduct.description,
          'imageUrl': ''
        };
        _imageUrlEditingController.text = _editedProduct.imageUrl;
      }
    }

    isInit = false;

    super.didChangeDependencies();
  }

  void saveForm() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id.toString(), _editedProduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Some thing is wrong'),
                content: Text('sorry'),
              );
            });
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Error Occured'),
                  content: const Text('Some erro'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: const Text('Close'))
                  ],
                ));
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        // Navigator.pop(context);
      }
      // log(_editedProduct.title);
      // log(_editedProduct.prices.toString());
      // log(_editedProduct.description);
      // log(_editedProduct.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Screen'),
        actions: [
          IconButton(onPressed: saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initialValue['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'field should not be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value.toString(),
                              description: _editedProduct.description,
                              prices: _editedProduct.prices,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                          initialValue: initialValue['price'],
                          decoration: const InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'field should not be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                prices: double.parse(value.toString()),
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          }),
                      TextFormField(
                          initialValue: initialValue['description'],
                          textInputAction: TextInputAction.next,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'field should not be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                description: value.toString(),
                                prices: _editedProduct.prices,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlEditingController.text.isEmpty
                                ? const Text('Enter the url')
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlEditingController.text,
                                    fit: BoxFit.contain,
                                    scale: 1,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                                controller: _imageUrlEditingController,
                                decoration: const InputDecoration(
                                    labelText: 'Image Url'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  //this is trigired when done on the keyboard is pressed
                                  saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'field should not be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      prices: _editedProduct.prices,
                                      imageUrl: value.toString(),
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite);
                                }),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
