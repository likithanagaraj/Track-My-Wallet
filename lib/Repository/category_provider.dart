  import 'package:flutter/widgets.dart';
import 'package:track_my_wallet_finance_app/data/categories.dart';
  import 'package:track_my_wallet_finance_app/model/categoryModel.dart';

  class CategoryProvider extends ChangeNotifier {

    final List<CategoryModel> category = [
      ...expenseCategories,
      ...incomeCategories
    ];

    CategoryModel getCategoryById(String Id){
      return category.firstWhere((e)=>e.id == Id);
    }
  }