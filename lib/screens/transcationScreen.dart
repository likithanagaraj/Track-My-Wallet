import 'package:flutter/material.dart' hide CloseButtonIcon;
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:track_my_wallet_finance_app/Repository/transactionRepository.dart';
import 'package:track_my_wallet_finance_app/Repository/transaction_provider.dart';
import 'package:track_my_wallet_finance_app/data/categories.dart';
import 'package:track_my_wallet_finance_app/model/categoryModel.dart';
import 'package:track_my_wallet_finance_app/widgets/bottomSheet.dart';
import 'package:track_my_wallet_finance_app/widgets/closeButton.dart';
import 'package:track_my_wallet_finance_app/widgets/contiuneButton.dart';
import 'package:track_my_wallet_finance_app/widgets/transactionInput.dart';
import '../constants.dart';
import '../model/transaction_type.dart';
import '../widgets/transactionActionSection.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  TransactionType selectedType = TransactionType.expense;
  CategoryModel? selectedCatgory;
  final FocusNode noteFocusNode = FocusNode();
  bool get isKeyboardVisible => MediaQuery.of(context).viewInsets.bottom > 0;
  final TransactionRepository repository = TransactionRepository();

  void handleTypeChange(TransactionType type) {
    setState(() {
      selectedType = type;
      selectedCatgory = null;
    });
  }

  void handleCategoryType(CategoryModel type) {
    setState(() {
      selectedCatgory = type;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    noteController = TextEditingController();

    //when Note is focused , rebuild UI
    noteFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  void handleKeyboardInput(String key) {
    print(key);
    final text = amountController.text;
    if (key == '⌫') {
      if (text.isNotEmpty) {
        amountController.text = text.substring(0, text.length - 1);
      }
      return;
    }
    if (key == '.') {
      if (text.contains('.')) return;
      amountController.text = text.isEmpty ? '0.' : text + '.';
      return;
    }

    amountController.text = text.isEmpty ? key : text + key;
  }

  List<CategoryModel> get activeCategory {
    return selectedType == TransactionType.expense
        ? expenseCategories
        : incomeCategories;
  }

  void showCategoryBottomSheet() {
    showFlexibleBottomSheet(
      bottomSheetColor: kWhiteColor,
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      builder: (context, scrollController, offset) => CategoryBottomSheet(
        category: activeCategory,
        scrollController: scrollController,
        selectedCategory: selectedCatgory,
        onCategorySelect: handleCategoryType,
      ),
      anchors: [0, 0.5, 1],
      isSafeArea: true,
    );
  }

  bool get isFormValid =>
      amountController.text != '0' && selectedCatgory != null;

  void handleContinue() {
    if(!isFormValid) return;

    final transaction = repository.create(
        amount: double.parse(amountController.text),
        categoryId: selectedCatgory!.id,
        type: selectedType,
        note: noteController.text.isEmpty ? null :noteController.text
    );

    print(transaction);
    context.read<TransactionProvider>().addTransaction(transaction);


    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: CloseButtonIcon(
        onTap: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 100,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TransactionInputSection(
                      noteFocusNode: noteFocusNode,
                      amountController: amountController,
                      noteController: noteController,
                      selectedType: selectedType,
                      hasCategorySelected: selectedCatgory != null,
                      onTypeChanged: handleTypeChange,
                      onCategoryTap: () => showCategoryBottomSheet(),
                    ),
                    SizedBox(height: isKeyboardVisible ? 20 : 40),
                    if (!isKeyboardVisible)
                      TransactionActionsSection(
                        onKeyboardInput: handleKeyboardInput,
                        onContinue: handleContinue,
                        isFormValid: isFormValid,
                      )
                    else
                      ContinueButton(
                        onTap: handleContinue ,
                        isEnabled: isFormValid,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}