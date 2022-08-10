import 'dart:io';
import 'package:ecommerce/core/constants/colors.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:ecommerce/core/utils/custom_buttons.dart';
import 'package:ecommerce/core/utils/custom_textfield.dart';
import 'package:ecommerce/core/utils/navigator.dart';
import 'package:ecommerce/features/add_product/presentation/provider/categories_provider.dart';
import 'package:ecommerce/features/add_product/presentation/provider/product_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/custom_toasts.dart';
import '../../../../data/remote/products/categories_services.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../../../shop/data/categories_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var categoryController = TextEditingController();
  var shippingTypeController = TextEditingController();
  var priceController = TextEditingController();
  var productNameController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Add Product",
          back: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const YMargin(30),
              OlxDescTextField(
                hintText: "Product Name",
                productName: "MacBook Air M1",
                controller: productNameController,
              ),
              const YMargin(10),
              OlxDescMoneyTextField(
                hintText: "Enter Price",
                productName: "How much do you sale for?",
                controller: priceController,
              ),
              const YMargin(10),
              GestureDetector(
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildCat();
                      });
                  if (kDebugMode) {
                    print(categoryController.text);
                  }
                }),
                child: OlxDescTextField(
                  hintText: "Pick Category",
                  productName: "Select a Category",
                  suffix: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  controller: categoryController,
                  enabled: false,
                ),
              ),
              const YMargin(10),
              GestureDetector(
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildOthers();
                      });
                  if (kDebugMode) {
                    print(categoryController.text);
                  }
                }),
                child: OlxDescTextField(
                  hintText: "Pick Shipping type",
                  productName: "Select a Shipping type",
                  suffix: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  enabled: false,
                  controller: shippingTypeController,
                ),
              ),
              const YMargin(10),
              OlxDescTextField(
                hintText: "Product Description",
                productName: "Write a description of your product",
                controller: descController,
              ),
              const YMargin(10),
              Row(
                children: [
                  Text(
                    "Upload",
                    style: Config.b1(context).copyWith(fontSize: 13),
                  ),
                ],
              ),
              const YMargin(10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _uploadImage();
                          });
                    },
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: OlxColor.olxPrimary),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const XMargin(10),
                  Expanded(
                      child: GridView.builder(
                          primary: false,
                          itemCount: images.length > 3 ? 3 : images.length,
                          padding: const EdgeInsets.all(0),
                          semanticChildCount: 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 5),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                // if have less than 4 image w build GalleryItemThumbnail
                                // if have mor than 4 build image number 3 with number for other images
                                child: images.length > 3 && index == 2
                                    ? buildImageNumbers(index)
                                    : Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(images[index].path)));
                          })),
                ],
              ),
              const YMargin(20),
              productNameController.text.trim().isNotEmpty &&
                      categoryController.text.trim().isNotEmpty &&
                      shippingTypeController.text.trim().isNotEmpty &&
                      images.isNotEmpty
                  ? OlxButton(
                      color: OlxColor.olxPrimary,
                      onTap: () => acceptedInputs(),
                      text: state.productState != ProductState.loading
                          ? "Continue"
                          : "Loading...",
                    )
                  : Container()
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //     color: Colors.white,
      //     padding: const EdgeInsets.only(bottom: 20),
      //     child: OlxButton(
      //       color: OlxColor.olxPrimary,
      //       onTap: () => acceptedInputs(),
      //       text: state.productState != ProductState.loading
      //           ? "Continue"
      //           : "Loading...",
      //     )),
    );
  }

  addProduct(BuildContext context) {
    Provider.of<CategoriesProvider>(context, listen: false)
        .addProduct(
            productNameController.text,
            priceController.text,
            categoryController.text,
            shippingTypeController.text,
            descController.text,
            images)
        .then((value) {
      productNameController.clear();
      priceController.clear();
      categoryController.clear();
      shippingTypeController.clear();
      descController.clear();
      images = [];
    });
  }

  acceptedInputs() async {
    try {
      var productName = productNameController.text;
      var price = priceController.text;
      var category = categoryController.text;
      var shipping = shippingTypeController.text;
      var desc = descController.text;
      if (productName.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in the Name of your Product");
        return;
      } else if (price.trim().isEmpty) {
        Toasts.showErrorToast("Please Type in the Price of your Product");
        return;
      } else if (category.trim().isEmpty) {
        Toasts.showErrorToast("Please Select a Product Category");
        return;
      } else if (shipping.trim().isEmpty) {
        Toasts.showErrorToast("Please Select a Shipping Type");
        return;
      } else if (desc.trim().isEmpty && desc.length >= 20) {
        Toasts.showErrorToast(
            "Write a Description or Your Description is less than 20 Words");
        return;
      } else if (images.isEmpty) {
        Toasts.showErrorToast("Select an Image");
        return;
      }
      addProduct(context);
    } catch (e) {
      Toasts.showErrorToast("An Error Occurred Unable to Upload data");
    } finally {}
  }

  var categoriesService = getIt<CategoriesService>();
  Future<List<CategoryModel>>? categoryList;
  List<CategoryModel>? retrievedCategoriesList;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    categoryList = categoriesService.fetchAllCategories();
    retrievedCategoriesList = await categoriesService.fetchAllCategories();
  }

  Widget _buildCat() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Select Category",
              style: Config.b3(context).copyWith(
                fontSize: 13,
                color: OlxColor.olxPrimary,
              ),
            ),
          ),
          FutureBuilder(
              future: categoryList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<CategoryModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    retrievedCategoriesList!.isEmpty) {
                  return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: const <Widget>[
                        Align(
                            alignment: AlignmentDirectional.center,
                            child: Text('No data available')),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: retrievedCategoriesList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              categoryController.text =
                                  snapshot.data![index].category;
                              if (kDebugMode) {
                                print(categoryController.text);
                              }
                              NavigationService().goBack();
                            });
                          },
                          title: Text(snapshot.data![index].category),
                        );
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  final List<String> _shippingType = ['Free Shipping', 'Paid'];

  Widget _buildOthers() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Select a Shipping Type",
              style: Config.b3(context).copyWith(
                fontSize: 13,
                color: OlxColor.olxPrimary,
              ),
            ),
          ),
          ListView.builder(
              itemCount: _shippingType.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      shippingTypeController.text = _shippingType[index];
                      if (kDebugMode) {
                        print(shippingTypeController.text);
                      }
                      NavigationService().goBack();
                    });
                  },
                  title: Text(_shippingType[index]),
                );
              })
        ],
      ),
    );
  }

  List<File> images = [];
  void _selectImage() async {
    List<Media>? res = await ImagesPicker.pick(
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect,
      ),
      gif: true,
      count: 5 - images.length,
      pickType: PickType.image,
    );

    if (res != null) {
      setState(() {
        images.addAll(res.map((e) => File(e.path)));
      });
    } else if (res == null) {
      Toasts.showErrorToast("No Image Selected");
    }
  }

// build image with number for other images
  Widget buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        // openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${images.length - index}",
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadImage() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Pick Image to Upload",
              style: Config.b3(context).copyWith(
                fontSize: 13,
                color: OlxColor.olxPrimary,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  primary: false,
                  itemCount: images.length > 3 ? 3 : images.length,
                  padding: const EdgeInsets.all(0),
                  semanticChildCount: 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 5),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        // if have less than 4 image w build GalleryItemThumbnail
                        // if have mor than 4 build image number 3 with number for other images
                        child: images.length > 3 && index == 2
                            ? buildImageNumbers(index)
                            : Image(
                                fit: BoxFit.cover,
                                image: AssetImage(images[index].path)));
                  })),
          const YMargin(20),
          images.length < 5
              ? OlxButton(
                  color: OlxColor.olxPrimary,
                  onTap: () {
                    setState(() {
                      _selectImage();
                    });
                    NavigationService().goBack();
                  },
                  text: "Upload",
                )
              : SizedBox.shrink(),
          const YMargin(20),
        ],
      ),
    );
  }
}

class OlxDescTextField extends StatelessWidget {
  final String hintText;
  final String productName;
  final Widget? suffix;
  final bool enabled;
  final TextEditingController? controller;
  const OlxDescTextField({
    required this.hintText,
    required this.productName,
    this.suffix,
    this.enabled = true,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              hintText,
              style: Config.b3(context).copyWith(fontSize: 13),
            ),
          ],
        ),
        const YMargin(8.0),
        OlxTextFormField(
          hintText: productName,
          suffixIcon: suffix,
          enabled: enabled,
          controller: controller,
        )
      ],
    );
  }
}

class OlxDescMoneyTextField extends StatelessWidget {
  final String hintText;
  final String productName;
  final TextEditingController? controller;
  const OlxDescMoneyTextField({
    required this.hintText,
    required this.productName,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              productName,
              style: Config.b3(context).copyWith(fontSize: 13),
            ),
          ],
        ),
        const YMargin(8.0),
        OlxMoneyTextFormField(
          hintText: hintText,
          inputType: TextInputType.number,
          controller: controller,
        ),
      ],
    );
  }
}

// class BrandList extends StatefulWidget {
//   String selectedCategory;
//   BrandList({required this.selectedCategory, Key? key}) : super(key: key);

//   @override
//   State<BrandList> createState() => _BrandListState();
// }

// class _BrandListState extends State<BrandList> {

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
