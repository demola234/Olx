import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/utils/config.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../data/remote/products/categories_services.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/view/setprofile/set_location.dart';
import '../../data/categories_model.dart';
import 'category_page.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: "Categories",
        ),
      ),
      body: Column(
        children: [
          const YMargin(20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FutureBuilder(
                  future: categoryList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CategoryModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: retrievedCategoriesList!.length,
                        itemBuilder: (context, index) {
                          return CategoryListItem(
                              categoryModel: snapshot.data![index]);
                        },
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        retrievedCategoriesList!.isEmpty) {
                      return Center(
                        child: ListView(
                          children: const <Widget>[
                            Align(
                                alignment: AlignmentDirectional.center,
                                child: Text('No data available')),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryListItem({
    required this.categoryModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService().navigateToScreen(CategoryPage(
          name: categoryModel.category,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: OlxColor.olxTextPrimary,
                        borderRadius: BorderRadius.circular(10.5)),
                    child: CachedNetworkImage(imageUrl: categoryModel.image)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    categoryModel.category,
                    style: Config.b1(context).copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
