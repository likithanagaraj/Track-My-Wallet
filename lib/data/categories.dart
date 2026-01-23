import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/categoryModel.dart';
import '../model/transaction_type.dart';

final List<CategoryModel> expenseCategories = [
  CategoryModel(
    id: 'food',
    categoryLabel: 'Food',
    categoryIcon: FontAwesomeIcons.bowlFood,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'travel',
    categoryLabel: 'Travel',
    categoryIcon: FontAwesomeIcons.plane,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'gym',
    categoryLabel: 'Gym',
    categoryIcon: FontAwesomeIcons.personWalking,
    type: TransactionType.expense,
  ),
];

final List<CategoryModel> incomeCategories = [
  CategoryModel(
    id: 'salary',
    categoryLabel: 'Salary',
    categoryIcon: FontAwesomeIcons.suitcase,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'freelance',
    categoryLabel: 'Freelance',
    categoryIcon: FontAwesomeIcons.computer,
    type: TransactionType.income,
  ),
];
