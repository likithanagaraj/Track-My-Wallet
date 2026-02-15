import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:track_my_wallet_finance_app/model/categoryModel.dart';

import 'categoryTile.dart';


class CategoryBottomSheet extends StatelessWidget {
  final List<CategoryModel> category;
  final ScrollController scrollController;
  final CategoryModel? selectedCategory ;
  final ValueChanged<CategoryModel> onCategorySelect;


  CategoryBottomSheet({required this.category,required this.scrollController,required this.onCategorySelect,required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: [
        _CategoryBottomSheetHeader(),
        const SizedBox(height: 16),
        ...category.map((category){
          final selected = selectedCategory?.id == category.id;
          return CategoryTile(
            category: category,
            isSelected: selected,
            onSelect: ()=>onCategorySelect(category),
          );
        })

      ],
    );
  }
}


class _CategoryBottomSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Category',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(FluentIcons.dismiss_24_regular, size: 24),
          ),
        ],
      ),
    );
  }
}

