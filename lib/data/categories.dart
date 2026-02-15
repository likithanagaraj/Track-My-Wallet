import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../model/categoryModel.dart';
import '../model/transaction_type.dart';

final List<CategoryModel> expenseCategories = [
  CategoryModel(
    id: 'food',
    categoryLabel: 'Food & Dining',
    categoryIcon: FluentIcons.food_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'groceries',
    categoryLabel: 'Groceries',
    categoryIcon: FluentIcons.cart_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'travel',
    categoryLabel: 'Travel',
    categoryIcon: FluentIcons.airplane_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'transportation',
    categoryLabel: 'Transportation',
    categoryIcon: FluentIcons.vehicle_car_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'gym',
    categoryLabel: 'Gym & Fitness',
    categoryIcon: FluentIcons.dumbbell_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'shopping',
    categoryLabel: 'Shopping',
    categoryIcon: FluentIcons.shopping_bag_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'entertainment',
    categoryLabel: 'Entertainment',
    categoryIcon: FluentIcons.movies_and_tv_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'healthcare',
    categoryLabel: 'Healthcare',
    categoryIcon: FluentIcons.heart_pulse_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'education',
    categoryLabel: 'Education',
    categoryIcon: FluentIcons.book_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'bills',
    categoryLabel: 'Bills & Utilities',
    categoryIcon: FluentIcons.receipt_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'rent',
    categoryLabel: 'Rent',
    categoryIcon: FluentIcons.home_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'insurance',
    categoryLabel: 'Insurance',
    categoryIcon: FluentIcons.shield_checkmark_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'gifts',
    categoryLabel: 'Gifts & Donations',
    categoryIcon: FluentIcons.gift_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'personal_care',
    categoryLabel: 'Personal Care',
    categoryIcon: FluentIcons.person_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'subscriptions',
    categoryLabel: 'Subscriptions',
    categoryIcon: FluentIcons.arrow_repeat_all_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'pets',
    categoryLabel: 'Pets',
    categoryIcon: FluentIcons.animal_cat_24_filled,
    type: TransactionType.expense,
  ),
  CategoryModel(
    id: 'other_expense',
    categoryLabel: 'Other',
    categoryIcon: FluentIcons.more_horizontal_24_filled,
    type: TransactionType.expense,
  ),
];

final List<CategoryModel> incomeCategories = [
  CategoryModel(
    id: 'salary',
    categoryLabel: 'Salary',
    categoryIcon: FluentIcons.money_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'freelance',
    categoryLabel: 'Freelance',
    categoryIcon: FluentIcons.briefcase_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'business',
    categoryLabel: 'Business',
    categoryIcon: FluentIcons.building_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'investment',
    categoryLabel: 'Investment',
    categoryIcon: FluentIcons.chart_multiple_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'rental',
    categoryLabel: 'Rental Income',
    categoryIcon: FluentIcons.key_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'bonus',
    categoryLabel: 'Bonus',
    categoryIcon: FluentIcons.star_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'refund',
    categoryLabel: 'Refund',
    categoryIcon: FluentIcons.arrow_undo_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'gift_received',
    categoryLabel: 'Gift Received',
    categoryIcon: FluentIcons.gift_card_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'interest',
    categoryLabel: 'Interest',
    categoryIcon: FluentIcons.savings_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'dividend',
    categoryLabel: 'Dividend',
    categoryIcon: FluentIcons.money_hand_24_filled,
    type: TransactionType.income,
  ),
  CategoryModel(
    id: 'other_income',
    categoryLabel: 'Other',
    categoryIcon: FluentIcons.more_horizontal_24_filled,
    type: TransactionType.income,
  ),
];
